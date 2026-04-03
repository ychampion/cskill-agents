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
Maintain a single list of cross-shell safe commands, run UNC-detection logic that matches `\\server\share` and server share, and reuse normalized path guards for config files/directories across both shells. Let both tools import the same maps so they refuse commands or file paths that fail the UNC/malicious config checks, and keep the regex/flag definitions centralized to avoid drift.

## Key Rules
- Only include commands that behave identically across bash and PowerShell; store them in external readonly commands so both tools can look them up without duplication.
- Perform UNC detection before executing commands on Windows, covering backslash, forward slash, mixed separators, IPv4/IPv6 addresses, and WebDAV patterns.
- Normalize paths via normalize case for comparison and reuse the dangerous files directories lists to reject edits/safe flag suggestions that touch sensitive config files.
- Keep these maps static so callers can memoize them and still share them among multiple shell entry points.

## Example Application
When launching either shell tool, load external readonly commands and call contains vulnerable unc path on every candidate path; whenever the path matches a dangerous file or UNC, reject the command and surface the same reason to both bash and PowerShell.

## Anti-Patterns (What NOT to do)
- Don’t re-derive UNC heuristics per tool; this invites Windows credential-exfiltration bugs.
- Don’t treat UNIX-only commands as cross-shell safe; the shared list must be conservative and portable.
