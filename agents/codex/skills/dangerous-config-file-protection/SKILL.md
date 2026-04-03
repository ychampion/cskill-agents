---
name: dangerous-config-file-protection
description: "Keep writes out of sensitive dotfiles and claude folders by checking canonicalized basenames before granting permission."
metadata:
  author: ychampion
---

# SKILL: Dangerous Config File Protection
**Domain:** sensitive-paths
**Trigger:** Guard every filesystem modification that touches `.git`, `.claude`, `.gitconfig`, or other config-critical paths before running the tool.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Maintain explicit lists of filenames and directories that should never be touched automatically. Before allowing any tool action, expand the requested path, normalize casing, and compare the basename or enclosing directory against those lists. If a match appears, decline the action or require a human permission grant with the narrowest scope possible.

## Key Rules
- Normalize to lowercase and POSIX separators before comparing, matching Windows/macOS semantics.
- Check both file-level names (e.g., `.gitconfig`) and directories (e.g., `.git`, `.claude`, `.vscode`) to block entire trees that hold secrets or tooling.
- Prefer generating narrow permission scopes when the path lives inside a controlled skill directory; otherwise, deny outright.
- Log each blocked attempt with a sanitized path so operators can trace why the denial happened.

## Example Application
When the user asks to edit `~/.claude/skills/confidential-skill/SKILL.md`, detect that the path enters `.claude`, normalize it, and refuse the automatic edit while suggesting a narrower permission grant instead of broad config-directory access.

## Anti-Patterns (What NOT to do)
- Don’t rely on loose wildcard matching that can accidentally miss or overmatch sensitive config paths.
- Don’t skip casing normalization; mixed-case variants of the same protected path must behave the same.
