---
name: ordered-streaming-tool-execution
description: "Buffer and execute streaming tool calls with concurrency awareness so results appear in request order even when multiple runners overlap."
metadata:
  author: ychampion
---

# SKILL: Ordered Streaming Tool Execution
**Domain:** tool-orchestration  
**Trigger:** Streaming toolUse input where progress must be shown in the original queue order, even if some tools run concurrently.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Maintain an ordered queue of tracked tools whose statuses include `queued`, `executing`, and `completed`. When a tool becomes eligible, start it only if no incompatible executor is running (non-concurrency-safe tools block the queue) and mark it `executing`. Buffer results and progress messages per tool and never yield them until all previous tools have finished; only then append their buffered messages to the output stream in the original order. This preserves a deterministic user view while still allowing safe tools to run in parallel.

## Key Rules
- Represent each tool use with a tracked descriptor holding queue position, assistant metadata, context modifiers, pending progress, and results.
- Only start tools when can execute tool permits; concurrent-safe ones may run alongside others but non-safe ones must wait for the queue drain.
- Buffer output (results/progress/heuristics) and flush it only after every earlier tool has resolved, so ordering cannot be disrupted by race conditions.

## Example Application
Implement a streaming tool runner for a conversational agent by streaming helper tasks into the executor, letting concurrency-safe tools run in parallel, and deferring emission until all prior toolUse entries have completed so the transcript matches the request order.

## Anti-Patterns (What NOT to do)
- Emit tool results as soon as they arrive in the background, which scrambles the perceived order and confuses the user.
- Ignore is concurrency safe and start mutually exclusive tools simultaneously, risking inconsistent shared resources.
- Fail to keep pending progress separate and merge them out of order, which causes partial updates to interleave incorrectly.
