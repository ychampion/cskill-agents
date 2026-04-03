---
name: concurrency-safe-tool-batching
description: "Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work."
metadata:
  author: ychampion
---

# SKILL: Concurrency-Safe Tool Batching
**Domain:** tool-orchestration  
**Trigger:** Use when one turn contains multiple tool calls and some are safe to run together while others mutate state or require exclusive execution.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Partition the requested tool calls into successive batches where each batch is either a set of read-only calls that may run together or a single exclusive call that must run alone. Decide concurrency safety from each tool’s declared behavior and validated inputs, not from naming conventions. Execute safe batches in parallel, then apply any shared-context updates only after the whole batch completes. Run mutating or stateful tools one at a time so ordering and side effects remain deterministic.

## Key Rules
- Treat a tool as concurrency-safe only after validating its input and checking its declared safety rules; if anything is ambiguous, fall back to serial execution.
- Append queued context modifiers from concurrent batches after they finish so the shared tool use context stays consistent before the next batch.
- Always reorder only read-only batches; non-read-only batches must run on their own and update context inline so ordering and side effects remain deterministic.

## Example Application
When building a CLI tool runner, first group together safe read-only lookups like file reads or searches, run that group in parallel, then execute any edit, write, or stateful shell step on its own. This gives you parallelism where it is safe without letting mutating tools race each other.

## Anti-Patterns (What NOT to do)
- Assume all tools are concurrency-safe and run them in parallel, which can break stateful tools like shell edits.
- Drop queued context modifiers from concurrent batches and let subsequent batches run on stale context, leading to permission and session problems.
- Merge tool use results out of order when non-read-only tools follow concurrent batches, which breaks user expectations about sequential effects.
