---
name: progressive-compaction-prompt
description: "Drive compaction summaries through structured prompts that sequence naming, artifacts, and invocation guidance before stripping analysis tags."
metadata:
  author: ychampion
---

# SKILL: Progressive Compaction Prompt
**Domain:** context-management
**Trigger:** Apply when composing compact summaries so each round captures intent, context, per-step detail, and invocation cues before the final summary is stripped to user-friendly text.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Wrap each compaction request in a staged prompt that asks the model to summarize in a deliberate sequence instead of freeform prose. The prompt should first ban tool use, then walk through the important dimensions of the conversation such as goals, decisions, artifacts, open work, and invocation guidance. Ask the model to emit a structured draft that is easy for post-processing to clean up, then strip the drafting scaffolding before storing or showing the final summary. Add only the minimum follow-up instructions needed so an automated agent can resume from the compacted state without asking redundant questions.

## Key Rules
- Use a dedicated no-tools preamble so the compaction agent never tries to call tools while summarizing.
- Pick the prompt template based on scope: one template for full-session compaction and a different one for partial compaction that preserves recent turns verbatim.
- Keep the structured draft easy to clean: analysis scaffolding may exist temporarily, but the stored or displayed summary should be post-processed into plain readable text.
- Include only the follow-up instructions that downstream automation actually needs, such as whether to suppress clarification questions or where to find preserved transcript artifacts.
- Reuse the same prompt shape across compaction flows so summaries remain consistent enough for tooling to parse and compare.

## Example Application
Before resuming a long-running session after compaction, generate the summary with the staged prompt, run a cleanup pass that removes drafting tags, and attach the final summary to the resumed session along with any preserved transcript references. The next agent can then continue from a concise, automation-friendly handoff instead of reprocessing the trimmed history.

## Anti-Patterns (What NOT to do)
- Do not rely on freeform summarization when the compacted state must preserve goals, artifacts, and next-step cues for automation.
- Do not expose raw drafting scaffolding or analysis tags to downstream consumers if a cleanup step is expected.
- Do not stuff mode-specific instructions into every compaction prompt by default; only include what the current compaction flow actually needs.
