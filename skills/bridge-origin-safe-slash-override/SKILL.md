---
name: bridge-origin-safe-slash-override
description: "Keep remote slash-command skipping enabled by default, then reopen it only for bridge-safe commands while denying unsafe local commands with a friendly local response."
metadata:
  author: ychampion
---

# SKILL: Bridge Origin Safe Slash Override
**Domain:** remote-input-safety
**Trigger:** Apply when remotely delivered input should still default to plain-text slash handling, but a trusted bridge path needs to selectively re-enable only the slash commands that are safe to execute remotely.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Keep skip slash commands turned on for bridge-delivered input as the baseline defense. When that input starts with `/` and is marked bridge origin, parse and resolve the slash command locally before the normal slash gate runs. Only clear the skip flag if the resolved command passes the bridge-safety predicate; otherwise, intercept known-but-unsafe commands with a friendly local denial and never forward the raw slash text to the model. If the command is unknown or unparseable, fall back to plain text so remote users keep the pre-override behavior instead of getting a local "unknown command" error.

## Key Rules
- Preserve skip slash commands true at enqueue time for remote input so exit-word suppression, immediate-command fast paths, and any other direct flag checks still see the defensive default.
- Reopen slash handling only after all three checks pass: the message is bridge-originated, starts with `/`, and resolves to a command that passes bridge-safety filtering.
- Treat known unsafe commands, especially local-jsx or terminal-only ones, as a local UX case rather than a model prompt: return a friendly denial such as "config isn't available over Remote Control." and stop before querying.
- Let unknown or malformed slash text fall through as plain text rather than converting it into a new local error surface for remote users.
- Keep discovery aligned with execution by advertising only bridge-safe commands to remote clients whenever possible; the override should narrow execution, not widen the visible command set.

## Example Application
A mobile client injects deploy docs through Remote Control with skip slash commands still set to true. The bridge path parses the command, confirms it is bridge-safe, clears the skip, and lets normal slash-command execution continue. The same client sends config; the command resolves locally but fails the bridge-safety check, so the system replies with a local denial message and never exposes config to the model as raw text. If the client sends shrug, which does not resolve to a known command, the input remains plain text.

## Anti-Patterns (What NOT to do)
- Do not disable slash skipping for all bridge traffic up front; that reopens the exact remote-command surface the default suppression was meant to close.
- Do not pass known unsafe slash commands through as ordinary model text; the model should not have to interpret config after local policy already knows it is disallowed remotely.
- Do not reject unknown bridge slash text with a new "Unknown skill" style error; preserving plain-text fallback avoids breaking ordinary remote messages that happen to start with `/`.
