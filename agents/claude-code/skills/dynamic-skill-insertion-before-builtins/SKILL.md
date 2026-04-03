---
name: dynamic-skill-insertion-before-builtins
description: "Merge runtime-discovered commands into an existing command registry by deduping them against the enabled base surface and inserting them at a stable boundary before built-in commands."
metadata:
  author: ychampion
---

# SKILL: Dynamic Skill Insertion Before Builtins
**Domain:** Command Architecture
**Trigger:** Use when commands can be discovered at runtime and must be added to a prebuilt command list without duplicating enabled entries or scrambling the established built-in ordering.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
First compute the user-visible base command list, then treat that enabled surface as the dedupe authority for any newly discovered runtime commands. Filter dynamic entries by stable command name against that base set so you only add commands that are truly absent for the current session. Instead of re-sorting or rebuilding the whole registry, locate the first built-in command and splice the new dynamic entries immediately before it. This keeps plugin and external discoveries ahead of the built-in block while preserving the built-ins' internal order and keeping the command surface stable across refreshes.

## Key Rules
- Deduplicate against the already filtered base surface, not against every raw registered command, so disabled or unavailable commands do not wrongly block a dynamic replacement.
- Use a stable identity key such as the command name when checking whether a dynamic entry is already present.
- Keep a fast path that returns the base list unchanged when no dynamic commands exist or when all of them collapse during dedupe.
- Derive the insertion anchor from the built-in command set, then splice once at that boundary instead of globally reordering the registry.
- If no built-in boundary exists in the current list, append the dynamic entries so discovery still succeeds without special-case failures.

## Example Application
If a CLI can discover new slash commands while scanning the working tree, first build the enabled command list the user can actually run, remove any discovered commands whose names already appear there, then insert the remaining discoveries just before the first built-in help or config command. The runtime additions stay visible near other extensible commands without shuffling the built-in command block on each scan.

## Anti-Patterns (What NOT to do)
- Do not deduplicate against the raw registry before availability checks; hidden commands will suppress dynamic commands the user should actually see.
- Do not sort the full command list again after discovery; repeated scans will create unstable ordering and noisy diffs in the command surface.
- Do not anchor insertion to source load order alone; use an explicit built-in boundary so additive discoveries land in a predictable location.
