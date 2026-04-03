---
name: bridge-safe-command-advertising
description: "Advertise only slash commands that a bridge client can actually invoke by filtering announcements with the same bridge-safety predicate used at execution time."
metadata:
  author: ychampion
---

# SKILL: Bridge Safe Command Advertising
**Domain:** command-architecture
**Trigger:** Use when a bridged or remote client receives an announced slash-command list and that list must stay aligned with the commands the runtime will actually execute for bridge-originated input.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Filter the command list before serializing any remote capability announcement, and filter it with the exact same bridge-safety predicate the runtime will use when the remote client later invokes a slash command. Let the shared serializer keep its generic user-invocable check, but pass it a prefiltered list that already excludes bridge-unsafe commands. This keeps the announced surface honest: every command the client sees is one the bridge path can actually execute, and every command the bridge path rejects stays undiscoverable instead of becoming a guaranteed dead end.

## Key Rules
- Reuse the runtime bridge-safety predicate at announcement time instead of inventing a second listing-only filter.
- Apply the bridge-safe filter before generic serializers flatten commands into plain names; once only names remain, execution-policy drift is harder to spot and correct.
- Keep shared message builders transport-agnostic: they may still filter out non-user-invocable entries, but transport-specific safety should be decided by the caller that owns that transport.
- Treat advertised command lists as part of the execution contract, not as best-effort discoverability metadata.
- When bridge execution rules change, update the shared predicate so announcement and invocation stay synchronized automatically.

## Example Application
When a CLI session opens a phone companion over a bridge and emits system init, filter the command registry through is bridge safe command before calling the generic init-message builder. The serialized `slash_commands` list then includes summary and compact, but omits local-only UI commands such as model that the bridge path would reject later.

## Anti-Patterns (What NOT to do)
- Do not advertise every user-invocable command and rely on runtime failures to teach remote clients what is unsupported.
- Do not maintain a separate announcement-only allowlist that can drift away from the real bridge execution gate.
- Do not hide transport-specific safety inside the generic serializer when different callers may need different execution contracts.
