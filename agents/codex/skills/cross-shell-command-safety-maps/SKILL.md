---
name: cross-shell-command-safety-maps
description: "Describe how to centralize cross-platform safe commands, UNC detection, and per-shell path guards so every shell tool shares the same policy."
metadata:
  author: ychampion
---

# SKILL: Cross Shell Command Safety Maps
**Domain:** security
**Trigger:** Apply this when you need to enforce identical permissions across bash/PowerShell, detect UNC paths, and keep dangerous config files hidden to both shells.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Maintain one shared policy source for command allowlists, UNC-path rejection, and sensitive-path checks, then have both the Bash and PowerShell entrypoints consume that same policy. Each shell may parse its own command syntax, but the decisions about what is read-only, what path patterns are dangerous, and when to reject remote shares should come from the same central maps. This keeps cross-platform behavior aligned and prevents one shell surface from quietly drifting into a weaker security posture.

## Key Rules
- Only include commands that behave predictably across both shells; the shared allowlist should stay conservative and portable.
- Perform UNC detection before executing commands on Windows, covering backslash, forward slash, mixed separators, IPv4/IPv6 addresses, and WebDAV patterns.
- Normalize candidate paths before comparison and reuse the same sensitive-path deny rules in both shell tools.
- Keep these maps static so callers can memoize them and still share them among multiple shell entry points.

## Example Application
When launching either shell tool, load the shared read-only command map and run the same UNC-path and sensitive-path checks before execution. A path that is rejected in Bash should be rejected for the same reason in PowerShell.

## Anti-Patterns (What NOT to do)
- Don’t re-derive UNC heuristics per tool; this invites Windows credential-exfiltration bugs.
- Don’t treat UNIX-only commands as cross-shell safe; the shared list must be conservative and portable.
