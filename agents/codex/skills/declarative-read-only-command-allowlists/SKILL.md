---
name: declarative-read-only-command-allowlists
description: "Express shell-command safety as declarative flag maps so tooling knows exactly what passes."
metadata:
  author: ychampion
---

# SKILL: Declarative Read Only Command Allowlists
**Domain:** shell-validation
**Trigger:** Use when you want tooling to enforce read-only shell commands by referencing a static map of command names, allowed flags, and supplemental callbacks.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Define each safe command as a declarative entry keyed by its full name such as `git diff`, `docker logs`, or `rg`. Each entry should describe allowed flags, argument rules, and any extra validation needed for edge cases. Build the shell policy layer by consulting these tables instead of scattering safety logic across the executor. The executor then only needs to look up the command, validate its flags against the declarative spec, and reject anything not explicitly allowed.

## Key Rules
- Keep every command entry immutable so runtime validators can memoize them and share the same configuration between BashTool and PowerShellTool.
- Prefer breaking large maps (git, docker, rg) into shared flag groups (e.g., git stat flags, git color flags) to avoid duplication and to make audits easy.
- Allow supplemental callbacks only for the few commands that need extra context (e.g., `git remote show` needs remote-name validation) and keep them side-effect-free.
- Treat unknown commands or flags as rejects, making the declarative tables the only source of truth for allowed operations.

## Example Application
When building a new shell agent, load the read-only command map, validate the tokenized flags for each request against that map, and allow execution only when the command matches an approved entry. This makes the policy auditable and consistent across shells.

## Anti-Patterns (What NOT to do)
- Don’t hardwire flag lists inside the tool executor; that risks drift between `git diff` and the security policy.
- Don’t extend the tables casually; every new command or flag should be justified and validated against the same argument rules as the rest of the policy.
