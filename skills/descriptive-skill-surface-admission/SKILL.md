---
name: descriptive-skill-surface-admission
description: "Use source-aware admission rules so trusted local skills can surface automatically while plugin or MCP-provided entries must supply explicit descriptive metadata."
metadata:
  author: ychampion
---

# SKILL: Descriptive Skill Surface Admission
**Domain:** tool-design
**Trigger:** Use when a command or skill catalog mixes trusted local sources with external providers and you need a predictable rule for which entries may appear without manual curation.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Split listing admission into two lanes based on source trust. Automatically admit curated local sources such as bundled skills, project-local skills, or other maintained first-party directories because those entries can safely fall back to derived summaries when metadata is sparse. Require external or extensible sources such as plugins and MCP-provided entries to supply explicit human-readable description or trigger metadata before they appear in the user-facing surface. This keeps local discovery easy without letting opaque third-party items pollute the shared catalog.

## Key Rules
- Decide admission from both source and metadata quality; provenance alone is not enough for external ecosystems.
- Maintain an allowlist for trusted local sources that may rely on derived descriptions instead of explicit descriptive fields.
- Require plugin, marketplace, or MCP-provided entries to expose meaningful descriptive metadata before listing them.
- Apply the admission filter only after excluding non-skill entries such as built-ins, disabled model-invocation commands, or non-prompt command types.
- Keep the rule deterministic and source-specific so users can predict why one class of skills auto-surfaces while another stays hidden until documented.

## Example Application
If you are building a terminal assistant that loads skills from a local skills folder, a bundled starter pack, and several third-party MCP servers, let the bundled and project-local skills appear immediately even when they only have a first-line summary. For the MCP and plugin sources, hide entries until they declare a proper description or a clear when to use sentence, so the skill picker stays understandable instead of filling with opaque names.

## Anti-Patterns (What NOT to do)
- Do not apply a single admission rule to every source; treating bundled local skills like untrusted plugins creates unnecessary friction, while treating plugins like curated local assets floods the surface with low-context entries.
- Do not surface third-party commands solely because they exist; missing descriptive metadata makes the catalog noisy and forces the model to guess what each external entry does.
