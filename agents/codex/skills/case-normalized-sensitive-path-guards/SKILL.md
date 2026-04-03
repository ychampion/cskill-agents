---
name: case-normalized-sensitive-path-guards
description: "Normalize filesystem paths and reject matches that try to spoof sensitive directories with mixed case or alternate separators."
metadata:
  author: ychampion
---

# SKILL: Case-Normalized Sensitive Path Guards
**Domain:** sensitive-paths
**Trigger:** Use whenever user input targets `.claude`, dotfiles, or other dangerous locations on case-insensitive filesystems such as Windows and macOS.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Normalize every candidate path before comparing it against the sensitive-path denylist. That means lowercasing when the platform is case-insensitive and standardizing separators so `\` and `/` are treated consistently. Compare the normalized path against intact dangerous filenames and directory suffixes, not against the raw user input. This closes bypasses that rely on mixed case or alternate separators to sneak past exact-match checks.

## Key Rules
- Always canonicalize separators (`/` vs `\`) with an OS-aware helper so sensitive paths still match across shells and platforms.
- Reject normalized paths that end with the dangerous list entries, even if the original case or separator mix was different.
- Use this normalized result once per decision and reuse it for multiple rules (path scope detection, dangerous file detection, etc.) to avoid double work.
- Keep the normalization utility deterministic; it should never return a trimmed path that differs semantically from the original.

## Example Application
Before granting an edit permission to `~/.claude/settings.local.json`, normalize the path, detect that it still ends in `.claude/settings.local.json`, and route it through the strict config-file safety gate.

## Anti-Patterns (What NOT to do)
- Don’t compare raw paths directly; that misses exploits that only change letter casing or mix separators.
- Avoid normalizing only once per session — do it every time a new path is evaluated so dynamic paths stay protected.
