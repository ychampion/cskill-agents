---
name: canonical-worktree-path-normalization
description: "Resolve repo-relative paths against the canonical checkout root so shared state stays stable across Git worktrees."
metadata:
  author: ychampion
---

# SKILL: Canonical Worktree Path Normalization
**Domain:** git-worktree
**Trigger:** Use when repo-relative paths are written into shared or user-global state and the same project may be opened from multiple worktrees.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Normalize relative paths against the repository’s canonical root rather than the current worktree directory before persisting them into shared state. This prevents each worktree session from rewriting the same logical source to a different absolute path, and it avoids leaving dead install locations behind when a temporary worktree disappears. Keep the normalization local to the persistence boundary so upstream callers can continue using project-relative configuration naturally.

## Key Rules
- Resolve relative project paths at the point where they are compared against or written into shared state.
- Prefer the canonical Git root over the active worktree path whenever the stored state outlives a single checkout.
- Preserve already-absolute paths as-is; normalization is for relative project references only.
- Use the same normalized path for both comparison and write decisions so diff logic stays stable.
- Treat this as a stability contract for shared metadata, not merely a convenience for path formatting.

## Example Application
If plugin sources are declared as marketplace inside repository settings but stored in a global config file as absolute paths, resolve them against the main checkout root. Opening the repo from a feature worktree then compares equal to the existing entry instead of churning the stored path on every session.

## Anti-Patterns (What NOT to do)
- Do not persist worktree-specific absolute paths into user-global registries when the logical source belongs to the repo as a whole.
- Do not normalize only on writes but compare against raw relative paths on reads; the system will oscillate between equivalent representations.
