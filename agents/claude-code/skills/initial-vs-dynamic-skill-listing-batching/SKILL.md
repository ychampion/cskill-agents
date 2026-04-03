---
name: initial-vs-dynamic-skill-listing-batching
description: "Mark first-time skill listings differently from later deltas so attachment consumers can distinguish bootstrap exposure from incremental updates."
metadata:
  author: ychampion
---

# SKILL: Initial-vs-Dynamic Skill Listing Batching
**Domain:** skill-listing
**Trigger:** Apply when a listing or announcement stream needs to tell consumers whether they are seeing the first full exposure or an incremental update.
**Source Pattern:** Distilled from reviewed skill-listing and attachment-stream implementations.

## Core Method
Use prior-sent state to classify each listing batch before you mutate that state. If nothing has been sent yet, tag the outgoing payload as the initial batch; otherwise tag it as a dynamic delta. This lets downstream consumers render bootstrap and update flows differently without re-deriving history from raw command lists. The classification should happen immediately before the send-state is updated so it reflects what the consumer is about to receive, not what was already persisted afterward.

## Key Rules
- Compute the initial-versus-dynamic flag from the pre-send state, not after mutating the sent set.
- Keep the batch classification attached to the outgoing payload so downstream consumers do not need to infer it indirectly.
- Update the sent-state immediately after deciding what will be emitted so later batches classify correctly.
- Return no payload at all when there are no new items; an empty delta should not masquerade as either an initial or dynamic batch.

## Example Application
If a terminal agent announces available slash commands, mark the first emitted attachment as `isInitial: true` so the UI can show an onboarding-style listing. When a plugin reload later adds two commands, emit only those new commands with `isInitial: false` so the UI treats them as a compact delta update.

## Anti-Patterns (What NOT to do)
- Do not infer initial-versus-dynamic by batch size alone; a small first batch and a small later delta can look identical.
- Do not compute the flag after adding the new items to the sent set; that turns the first batch into a false dynamic update.
