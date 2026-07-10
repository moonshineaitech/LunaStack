---
name: cloud-networking
description: Use when designing or reviewing a VPC/VNet layout, choosing how workloads reach cloud services and the internet, or hunting a surprise data-transfer bill. Produces a network design card that enforces private-by-default subnets, sizes CIDRs for growth, routes service traffic through PrivateLink-class endpoints instead of NAT, prices the egress paths, and states an explicit IPv6 position.
---

# /cloud-networking — Private by Default, Priced per Path

Use to design a VPC/VNet layout where workloads are private by default, service traffic bypasses NAT, and every egress path has a known dollar cost.

**Persona: Cloud network architect who reads the data-transfer line of the bill first.** You lay out CIDRs for the org you'll be in five years, put nothing on a public IP that isn't a load balancer, and price every packet's path before it flows. You do not open security groups to make a deploy work, and you do not treat NAT gateways as free plumbing.

Carve address space top-down with an **IPAM** (AWS VPC IPAM, Azure IPAM, or NetBox) before the first VPC exists: non-overlapping /16s per environment-region, subnets sized so no tier starts under a /24, and never 10.0.0.0/16 for everything — overlaps are what force NAT hairpins and kill VPC peering later. **Private-by-default** means workload subnets have no route to an internet gateway and no auto-assigned public IPs; only ALB/NLB and NAT/egress appliances live in public subnets, and inter-VPC traffic flows over peering (free intra-AZ) or a Transit Gateway/hub-VNet (~$0.02/GB processing — worth it past roughly a dozen VPCs, overkill before). The classic bill-killer is service traffic through NAT: a NAT gateway charges ~$0.045/hr plus ~$0.045/GB *processed*, so pods pulling from S3 or ECR through NAT pay per gigabyte for traffic that gateway endpoints (S3, DynamoDB) carry **free**. For everything else there are **PrivateLink-class interface endpoints** (AWS PrivateLink, Azure Private Endpoint, GCP Private Service Connect) at ~$0.01/hr/AZ + ~$0.01/GB — the break-even is commonly ~100–200GB/month per service, and they also keep traffic off the public internet, which your compliance story needs anyway. On **IPv6, the 2026 reality**: public IPv4 costs ~$0.005/hr (~$3.65/month) per address on AWS and rising everywhere, so new VPCs should be dual-stack with IPv6-only private subnets where the stack allows (EKS supports IPv6-only pods; plenty of third-party SaaS and some managed services still don't, so pure IPv6-only estates remain rare — dual-stack is the defensible default, not a punt). Same-region cross-AZ transfer at ~$0.01/GB each way quietly dominates chatty microservice meshes — use topology-aware routing before buying a service mesh to fix it. Rule: **No workload subnet gets a default route to the internet; every flow to a cloud service goes over a gateway or PrivateLink-class endpoint, and any remaining NAT-processed traffic above ~100GB/month per service is a design bug to fix, not a cost to accept.**

BAD: "Put the EKS nodes in public subnets with public IPs so they can pull images, and open the security group to 0.0.0.0/0 on the node port" (every node is internet-reachable attack surface, image pulls ride NAT-priced paths or worse, and one leaked kubeconfig away from breach). GOOD: "Nodes in private subnets, ECR and S3 via gateway/interface endpoints, ingress only through the ALB in public subnets, egress through a single inspected NAT path with flow logs on."

```
NETWORK DESIGN — [vpc/env]
═══════════════════════════
CIDR:         [/16] from IPAM pool [name] · overlap check: [clean | CONFLICT]
Subnets:      public=[LB/NAT only] · private=[app] · isolated=[data, no egress]
Endpoints:    gateway=[S3,DynamoDB] · interface=[ECR,STS,Logs,...] @ [$X/mo]
NAT residue:  [GB/mo] × $0.045 = [$X/mo] · top talkers: [service list]
Inter-VPC:    [peering | TGW/hub @ ~$0.02/GB] · cross-AZ chatter: [$X/mo]
IPv6:         [dual-stack | IPv6-only subnets: which] · public IPv4 count: [N × $3.65/mo]
Flow logs:    [on → dest | OFF — no forensics]
═══════════════════════════
```

Skip when: it's a single-developer sandbox account with default-VPC throwaway resources, or the platform abstracts the network entirely (Cloudflare Workers, Vercel, Fly.io) and your only knob is egress allowlisting.

Gotchas: an interface endpoint per service per AZ per VPC multiplies fast — centralize endpoints in a shared-services VPC with Route 53 private hosted zones instead of stamping them into every VPC; security groups referencing "0.0.0.0/0 temporarily" during an incident become permanent — attach an expiry ticket or use time-boxed rules; VPC peering is non-transitive, so A↔B and B↔C does not give A↔C and teams discover this mid-migration; and NAT gateways are per-AZ — routing all AZs through one NAT saves hourly cost but adds cross-AZ transfer and makes that AZ your single egress point of failure.
