---
name: fast-worktree-reuse-with-head-pointer-checks
description: "Resume existing worktrees quickly by checking stored HEAD pointers before fetching or recreating."
metadata:
  author: ychampion
---

# SKILL: Fast Worktree Reuse With Head Pointer Checks
**Domain:** git-worktree
**Trigger:** Apply when the user asks to enter or resume a named worktree and you want to avoid redundant `git fetch`/`git worktree add` calls if the worktree already exists.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Before reaching for `git worktree add`, compute the worktree path and read its git head pointer directly (no subprocess). If the file exists and contains a SHA, treat the worktree as already created: return the path/branch, skip fetch, and let the CLI proceed immediately. Only when the HEAD file is missing do you fetch and `git worktree add`, knowing the directory is missing or corrupted.

## Key Rules
- Read claude worktrees <slug head with read worktree head sha before any git fetch/add so the fast-path returns instantly when the worktree already exists.
- When the fast-path finds a head, skip `mkdir`, `fetch`, and hook execution to minimize CLIs waiting on network calls.
- Only run the fetch/add sequence when the head pointer is absent, ensuring deterministic worktree creation timing.
- Capture the computed worktree branch, head commit, and `existed` flag so calling code can log a clear message.

## Example Application
For a “worktree resume” command, call this skill each time by deriving the slug, invoking the head-read fast-path, and only running `git fetch` when head data is missing, so most resumes finish in the same tick regardless of external network speed.

## Anti-Patterns (What NOT to do)
- Don’t always fetch/padded-add even when the directory already exists; that doubles command latency and can fail if credentials are missing.
- Avoid relying on `git worktree list` parsing alone—direct HEAD reading is cheaper and doesn’t require running git.
- Don’t ignore the `existed` boolean; downstream message/choices should reflect whether the worktree was reused or freshly created.
