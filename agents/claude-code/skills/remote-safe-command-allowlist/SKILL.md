---
name: remote-safe-command-allowlist
description: "Define a narrow explicit set of commands that stay available in remote mode because they only affect local UI state, then reuse that set at startup and after handshake refinement."
metadata:
  author: ychampion
---

# SKILL: Remote Safe Command Allowlist
**Domain:** command-architecture
**Trigger:** Use when a remote session can expose a subset of local commands, but only commands with no filesystem, shell, IDE, or other host-bound dependencies should remain available.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Define one explicit allowlist for commands that are safe in remote mode because they only affect local TUI state or emit benign local information. Apply that allowlist before the remote REPL first renders so unsafe commands never flash into the initial command surface during handshake. Then reuse the same allowlist when the remote backend later narrows the advertised command list, preserving the locally safe commands alongside the server-provided set. This gives remote sessions one stable safety contract instead of separate startup and post-init rules that can drift apart.

## Key Rules
- Keep remote safety as an explicit reviewed allowlist; default every other local command to blocked unless it proves it has no host-bound side effects.
- Reserve the allowlist for commands that only touch local UI state or similarly benign local behavior, not commands that need filesystem, git, shell, IDE, MCP, or other workstation context.
- Reuse the same allowlist at every remote-surface boundary, including initial pre-render filtering and later handshake refinement, so the visible command set stays consistent.
- Filter before the remote UI renders, not only after the backend init arrives; preventing a transient unsafe surface is part of the method.
- Preserve locally safe commands even when the remote backend returns its own command set, because some commands are safe precisely due to being local-only helpers.

## Example Application
If a coding agent launches a mobile companion mode, create a remote safe commands set containing only commands like clear-screen, help, theme switching, or copying the last response. Filter the command palette through that set before the mobile UI appears, then when the remote server reports its own supported commands, merge that list with the same reviewed local-safe set so the user keeps harmless local controls without ever seeing unsafe host-bound actions.

## Anti-Patterns (What NOT to do)
- Do not infer remote safety from command type or load source alone; a command can be local and still depend on host resources that remote mode cannot safely touch.
- Do not wait for the remote handshake before filtering; even a brief pre-init window that exposes unsafe commands creates a race and inconsistent UX.
- Do not maintain separate startup and post-handshake allowlists; drift between those lists makes remote behavior hard to audit and reason about.
