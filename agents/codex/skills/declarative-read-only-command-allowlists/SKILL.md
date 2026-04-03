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
Define each safe command as an entry keyed by its full name (`git diff`, `docker logs`, `rg`) and supply a safe flags map plus optional callbacks such as the additional command is dangerous callback. Build every shell tool by filtering commands through these declarative entries rather than scattering permission logic across helpers; the tool simply looks up the config, validates flags, and rejects commands not listed.

## Key Rules
- Keep every command entry immutable so runtime validators can memoize them and share the same configuration between BashTool and PowerShellTool.
- Prefer breaking large maps (git, docker, rg) into shared flag groups (e.g., git stat flags, git color flags) to avoid duplication and to make audits easy.
- Allow supplemental callbacks only for the few commands that need extra context (e.g., `git remote show` needs remote-name validation) and keep them side-effect-free.
- Treat unknown commands or flags as rejects, making the declarative tables the only source of truth for allowed operations.

## Example Application
When building a new shell agent, load the read-only commands map, call validate flags with the command’s tokenized args, and propagate the safe list to tools bash so the agent can only run commands the security spec enumerates.

## Anti-Patterns (What NOT to do)
- Don’t hardwire flag lists inside the tool executor; that risks drift between `git diff` and the security policy.
- Don’t extend the tables without recording the reason and verifying every new flag type (`number`, `string`, etc.) still passes the validate flag argument checks.
