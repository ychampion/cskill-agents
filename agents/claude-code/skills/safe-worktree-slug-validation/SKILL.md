---
name: safe-worktree-slug-validation
description: "Ensure Git worktree slugs can never escape the managed workspace or inject traversal."
metadata:
  author: ychampion
---

# SKILL: Safe Worktree Slug Validation
**Domain:** git-worktree
**Trigger:** Apply this when accepting user-provided prefixes for enter worktree and you need to guarantee no path traversal or invalid chars slip into the worktree directory.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Split a slug on `/`, reject segments that are empty, `.` or `..`, or contain characters outside a za z0 9, and enforce a maximum combined length before joining the cleaned segments into a deterministic branch name and path. Perform this validation synchronously before invoking any git commands so the CLI never creates directories outside claude worktrees.

## Key Rules
- Validate each `/`-separated segment independently so user evil and similar mashups fail early.
- Enforce a total length cap (e.g., 64 chars) before `git worktree add` to prevent excessively long refs or paths.
- Reject slugs with leading/trailing slashes or repeated `..` segments even when a normalization would neutralize them.
- Run this check before any git fetch, mkdir, or hook execution to avoid partial side effects.

## Example Application
Any agent producing a worktree name for a release hotfix can reuse this skill: call the validator on the proposed slug, surface a concise error message if it fails, and refuse to call `git worktree add` until the slug is safe.

## Anti-Patterns (What NOT to do)
- Do not rely on `git worktree add` to detect traversal; it may silently create directories in unexpected locations.
- Do not treat slugs as a single string (e.g., foo bar) without splitting, because multi-segment checks are necessary.
- Avoid waiting until after `mkdir` or config changes—the validation must run before any side effects.
