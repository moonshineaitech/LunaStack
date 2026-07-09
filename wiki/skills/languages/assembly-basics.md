---
name: assembly-basics
description: Use when reading disassembly, debugging at the instruction level, or writing small assembly, and you need calling conventions and register discipline right. Produces a review against low-level traps.
---

# /assembly-basics — Reading & Writing Assembly

Use when staring at a disassembler, a crash dump, or hand-tuned asm.

**Persona: Low-Level Engineer.** You read the machine's actual instructions, respect the calling convention, and never clobber a register you promised to preserve.

Know the **calling convention** for the target ABI: on **x86-64 System V** (Linux/macOS), integer args go in `rdi, rsi, rdx, rcx, r8, r9`, return in `rax`; `rbx, rbp, r12-r15` are **callee-saved** (you must preserve them), the rest caller-saved. Windows x64 uses `rcx, rdx, r8, r9` + shadow space. Keep the **stack 16-byte aligned** at a `call` (a misalignment crashes SSE code). Distinguish syntax: **AT&T** (`mov src, dst`, `%` registers, GAS) vs **Intel** (`mov dst, src`, NASM/objdump default) — the operand order is reversed. When reading disassembly to debug, follow the data into/out of registers and watch the flags register for branches. For anything nontrivial, write in C and read the compiler's asm rather than hand-writing.

BAD: assuming `mov rax, rbx` copies rax→rbx because you're thinking in AT&T while reading Intel syntax — the direction is reversed. GOOD: confirm the syntax first; in Intel `mov rax, rbx` is rbx→rax (dst, src).

```
ASSEMBLY REVIEW
═══════════════
□ Correct ABI calling convention (arg registers, return reg)
□ Callee-saved registers preserved (rbx, rbp, r12-r15 on SysV)
□ Stack 16-byte aligned at call sites
□ Syntax identified (AT&T dst-last vs Intel dst-first)
□ Flags/branches traced when debugging
□ Prefer C + compiler asm over hand-writing where possible
```

Skip when: you're at a level where the compiler's output is fine and instruction-level detail isn't needed.

Gotchas: AT&T vs Intel reverse operand order — misread the direction and every conclusion is wrong. Clobbering a callee-saved register without restoring it corrupts the caller. Stack misalignment crashes SSE/aligned-move instructions.
