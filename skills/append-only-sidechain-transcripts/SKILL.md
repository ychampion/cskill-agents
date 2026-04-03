---
name: append-only-sidechain-transcripts
description: "Persist every subagent transcript entry by appending with explicit parent UUIDs so transcripts become a linear, resumable sidechain."
metadata:
  author: ychampion
---

# SKILL: Append-Only Sidechain Transcripts
**Domain:** session-storage
**Trigger:** Subagent transcript persistence must stay append-only so forked history can be resumed and sidechain readers see messages in strict chronological order.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Model each subagent transcript as an append-only event log with explicit ordering links or sequence checkpoints. Persist the seed messages once at startup, then append only durable milestones as the run progresses, ignoring ephemeral stream fragments that are not worth replaying later. Advance the transcript cursor only after a durable record is safely written so resumes, forks, and sidechain readers can reconstruct history in strict order without duplication.

## Key Rules
- Never rewrite, truncate, or backfill earlier transcript entries once they have been committed.
- Filter out ephemeral deltas and other transient stream fragments so the stored transcript contains only meaningful replay points.
- Advance the ordering cursor only after a durable write succeeds.
- Partition transcript storage by agent or workflow so replay stays local and sidechains do not collide.

## Example Application
When a workflow manager resumes a paused child agent, it can replay the append-only transcript to rebuild context exactly once and continue from the last durable checkpoint.

## Anti-Patterns
- Writing directly from raw streaming deltas or duplicating seed messages will corrupt the append-only history.
- Advancing the cursor before persistence succeeds can create gaps, races, or duplicate replay on resume.
