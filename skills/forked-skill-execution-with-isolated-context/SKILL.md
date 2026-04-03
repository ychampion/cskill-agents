---
name: forked-skill-execution-with-isolated-context
description: "Run SkillTool slash commands inside a forked sub-agent so the skill has isolated budget, telemetry, and lifecycle."
metadata:
  author: ychampion
---

# SKILL: Forked Skill Execution With Isolated Context
**Domain:** agentic-loop
**Trigger:** Load this skill when SkillTool needs to wrap a prompt command marked with `context:'fork'` into a sub-agent run that cannot touch the parent session state.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Merge the command metadata (model, effort, telemetry tags) into a cloned agent definition, record the forked skill invocation, and run the skill prompt through run agent so it executes in a dedicated loop with its own agent id. Buffer the streaming messages, emit progress when tool content appears, and once run agent completes extract and return a clean result string after releasing the temporary message buffer and invoked-skill state. The parent context still honors overrides (allowed tools, effort, model suffix) via context modifier, while telemetry uses sanitized names and agent IDs so the forked execution is auditable separately.

## Key Rules
- Only fork a skill when command context 'fork'; treat every other slash command as inline to avoid extra sub-agents.
- Feed the prepared prompt messages, modified get app state, and context options tools into run agent, tagging emitted messages with tool use id so downstream renderers can tie progress to this tool call.
- Emit progress events for every normalized message that contains `tool_use`/`tool_result` content so UI components can show streaming updates even though SkillTool owns the loop.
- After completion, clear invoked skills for the forked agent, compute result text defensively, and include the agent id in the returned tool result so callers can correlate logs or diagnostics.

## Example Application
If a CLI-style `review` skill needs to spawn its own interpreter to run analysis on a repo snapshot, mark it as `context:'fork'`, let SkillTool merge its effort override, and rely on this method to keep the review sub-agent separate while streaming progress back to the caller.

## Anti-Patterns (What NOT to do)
- Do not reuse run agent from the parent loop without copying the context; that leaks token budget and prompt state between skills.
- Do not skip clear invoked skills for agent after forked completion, otherwise compaction will unexpectedly rehydrate stale skill content.
