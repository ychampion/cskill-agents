---
name: slash-command-skill-classification-filter
description: "Derive a slash-command skill surface from a broader prompt-command registry by requiring descriptive metadata, excluding builtins, and admitting only a controlled set of origins plus explicit user-only commands."
metadata:
  author: ychampion
---

# SKILL: Slash-Command Skill Classification Filter
**Domain:** Command Architecture
**Trigger:** Use when a slash-command picker or human-facing skill list must be derived from a larger prompt-command registry without exposing builtin, undocumented, or wrongly sourced commands.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Build the slash-command skill surface as a curated filtered view over the broader command registry instead of treating every prompt command as a skill. Require each surfaced entry to be prompt-shaped, non-builtin, and backed by clear human-readable metadata such as a summary or trigger sentence. Admit only an approved set of source classes such as installed skills, bundled skills, and trusted plugins. If a command is intentionally user-invocable but not model-invocable, keep it visible in the human-facing picker while still excluding it from automatic model execution.

## Key Rules
- Start from the full command registry, then derive a dedicated slash-command skill subset with explicit admission rules rather than sharing a looser generic listing.
- Keep the filter scoped to prompt-type commands so execution semantics match the slash-command skill surface.
- Exclude builtin commands from this surface even if they are prompt-shaped; builtin command discovery belongs to a different UX path.
- Require descriptive metadata such as a summary or trigger sentence before a command can appear, so the user never sees opaque entries with no guidance.
- Restrict source admission to a controlled allowlist like `skills`, `plugin`, and `bundled` instead of assuming every external prompt command is a skill.
- Preserve an override path for manual-only commands when they should remain user-discoverable even though the model is not allowed to invoke them automatically.

## Example Application
If an editor assistant builds a skills palette from all registered prompt commands, first remove builtins, then keep only entries with clear description metadata, and finally admit only bundled skills, installed skill packs, approved plugin commands, plus a manual-only deployment helper that users may run themselves. The result is a human-facing palette that stays informative and intentionally curated without hiding useful manual commands.

## Anti-Patterns (What NOT to do)
- Do not expose every prompt command in the slash-command surface; that turns internal or contextless commands into noisy pseudo-skills.
- Do not rely on origin alone without description checks; undocumented commands make the picker harder to trust and harder to use.
- Do not exclude manual-only commands by default when the goal is human discovery; model-ineligible does not mean user-ineligible.
