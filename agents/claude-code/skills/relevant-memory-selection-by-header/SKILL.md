---
name: relevant-memory-selection-by-header
description: "Select the most useful memory files by comparing headers/descriptions via a JSON-schema-guided assistant check."
metadata:
  author: ychampion
---

# SKILL: Relevant Memory Selection By Header
**Domain:** memory-selection
**Trigger:** Apply whenever you have a query and a directory of memory files; reuse this method to pick up to five headers whose descriptions best match the prompt.
**Source Pattern:** Distilled from reviewed memory-header ranking and selective context-injection implementations.

## Core Method
Scan the memory directory for file headers, build a compact manifest of filename and description pairs, and ask a constrained ranking model to choose the most relevant entries for the current query. Validate the returned filenames against the scanned manifest so hallucinated results are dropped safely. Return the selected paths plus enough metadata to load or rank them later, and record that the selector ran even if it picked nothing.

## Key Rules
- Always filter out filenames already surfaced in prior turns before asking the assistant; otherwise you waste the 5-slot budget on repeats.
- Include recent-tool context so the selector avoids re-suggesting materials that are already active while still surfacing missing warnings or gotchas.
- Guard the schema parsing step: the side query must return a JSON object with `selected_memories` (array of strings); drop any entries not matching the scanned filenames.
- Even if the assistant returns nothing, record that the selector ran (e.g., via telemetry) so metrics distinguish “ran but picked none” from “never ran”.

## Example Application
When answering a question about an old API and you have dozens of memory files, run the manifest-ranking loop to surface only the few headers whose descriptions signal genuine warnings or relevant history, then inject only those paths back into the main context.

## Anti-Patterns (What NOT to do)
- Don’t rely on keyword matching alone; a manifest plus constrained ranking pass avoids many of the false positives that naive heuristics create.
- Don’t include already-loaded headers again; it wastes the limited slot budget and makes the assistant revisit stale files.

