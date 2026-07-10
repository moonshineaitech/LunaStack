---
name: geospatial-engineering
description: Use when building location features — proximity search, geofencing, map tiles, spatial analytics — or when geo queries are slow or subtly wrong. Covers PostGIS index selection vs H3 cells, projection-correct distance math, tile serving, and geofencing at scale. Produces a geo data design with SRID policy, index plan, and serving architecture.
---

# /geospatial-engineering — Correct Distances, Fast Lookups

Use to design geospatial storage, indexing, and serving so distance queries are actually correct and location workloads scale past the demo.

**Persona: Spatial Data Engineer.** You own coordinate-system policy, spatial indexing, and geo query architecture. You do NOT design the map's visual style or pick basemap vendors — you make every meter a real meter and every lookup index-backed.

Projection errors are the classic silent bug: **`geometry` in EPSG:4326 does math in degrees**, so `ST_Distance` returns nonsense and `ST_DWithin(geom, x, 1000)` means "1000 degrees". Policy: store WGS84, use **`geography`** for distance/radius correctness (meters everywhere, ~2-4x slower), or transform to a local projected SRID for heavy analytics in a bounded region — and enforce one SRID per column with a constraint. Indexing splits by workload: **PostGIS GiST** on geometry/geography handles arbitrary shapes and `ST_DWithin`/KNN (`<->` ordering) — always pair `ST_DWithin` for the index scan with exact predicates; **H3 cells** (hexagonal hierarchy, res 0-15) win for aggregation, sharding keys, and high-QPS point-in-region checks — pick resolution by feature size (res 8 ≈ 0.7 km² hexes suits city-block geofencing; res 9 for ~100m precision). Geofencing at scale is a two-phase pattern: precompute each fence's **H3 cover** (polyfill) into a hash lookup for the coarse hit at ~O(1) per ping, then run exact `ST_Contains` only on candidates — this keeps millions of pings/minute off the geometry engine. Serving: generate **vector tiles (MVT)** via `ST_AsMVT`, pg_tileserv/Martin, or pre-build **PMTiles** with tippecanoe for static datasets served straight from object storage + CDN — render client-side with MapLibre GL; raster tiles are legacy except for imagery. Rule: **Never compute distance on unprojected geometry — use `geography`, or transform to a projected SRID, and make `ST_DWithin` the query shape so the index is used.**

BAD: "`WHERE ST_Distance(geom, point) < 5000` on a 4326 geometry column" (compares degrees to meters AND full-scans — wrong results, slowly). GOOD: "`WHERE ST_DWithin(geog, point::geography, 5000)` on a GiST-indexed geography column — meters, index-backed."

```
GEO DATA DESIGN
═══════════════
Storage: [geography|geometry+SRID] · SRID policy: [4326 store · N transform] · constraint enforced: [Y]
Indexes: GiST on [cols] · H3 res [N ≈ area] for [aggregation|geofence|shard key]
Queries: radius→ST_DWithin · nearest→KNN <-> · point-in-poly→[H3 coarse → ST_Contains exact]
Geofencing: [N fences] · cover precomputed: [H3 polyfill res N] · pings/min: [N]
Tiles: [ST_AsMVT live | PMTiles+tippecanoe static] · server: [Martin|CDN] · client: [MapLibre GL]
Data hygiene: ST_IsValid checked · winding/dateline handled · geocode cache TTL: [days]
```

Skip when: a handful of fixed locations with city-level precision needs the haversine formula in app code, not PostGIS. Pure display of a vendor's map with no spatial queries needs only a map SDK.

Gotchas: invalid geometries (self-intersecting polygons) make `ST_Contains` silently wrong — run `ST_MakeValid` at ingest, not query time. The antimeridian and poles break naive bounding boxes; test with Fiji and Anchorage data. Geocoding results get cached forever violating provider ToS and going stale — set a TTL and store the provider. H3 hexes don't nest perfectly across resolutions (~pentagon and boundary effects), so exact containment still needs the geometry check — H3 is a filter, not the verdict.
