---
name: concurrency-safe-tool-batching
description: "Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work."
metadata:
  author: ychampion
---

# SKILL: Concurrency-Safe Tool Batching
**Domain:** tool-orchestration  
**Trigger:** Turn-level toolUse collections that mix read-only calls with ones that mutate state or require exclusive execution.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Partition the incoming toolUse messages into successive batches where each batch is either a single non-read-only toolRun or a series of read-only tools. Use a schema that evaluates is concurrency safe per batch by validating the tool’s own schema and is concurrency safe hook. Execute safe batches concurrently and accumulate their context modifiers after they finish before moving on, while forcing unsafe batches to run serially so they have exclusive access and the output ordering is kept stable.

## Key Rules
- Determine is concurrency safe by parsing each tool’s input through its schema and guarding against is concurrency safe exceptions; treat errors as unsafe.
- Append queued context modifiers from concurrent batches after they finish so the shared tool use context stays consistent before the next batch.
- Always reorder only read-only batches; non-read-only batches must run on their own and update context inline so ordering and side effects remain deterministic.

## Example Application
When building a tool runner for a CLI agent, follow this pattern by first checking each requested tool for read-only eligibility, batched read-only ones together, and run them through promise all while serializing writers; this keeps parallelism on safe paths and ensures serial ordering for mutating tools.

## Anti-Patterns (What NOT to do)
- Assume all tools are concurrency-safe and run them in parallel, which can break stateful tools like shell edits.
- Drop queued context modifiers from concurrent batches and let subsequent batches run on stale context, leading to permission and session problems.
- Merge tool use results out of order when non-read-only tools follow concurrent batches, which breaks user expectations about sequential effects.
