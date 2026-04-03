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
Keep remote slash-command parsing disabled by default for bridge-delivered input. If a remote message starts with `/`, inspect it locally first and resolve whether it maps to a known command. Re-enable slash handling only when the resolved command is explicitly bridge-safe; otherwise, intercept unsafe known commands with a friendly local denial and leave unknown slash text as plain text. This preserves the defensive default while still allowing a narrow, reviewed remote command surface.

## Key Rules
- Preserve the “treat slash text as plain text” default at enqueue time so every other fast path still sees the defensive baseline.
- Reopen slash handling only after all three checks pass: the message is bridge-originated, starts with `/`, and resolves to a command that passes bridge-safety filtering.
- Treat known unsafe commands, especially local-jsx or terminal-only ones, as a local UX case rather than a model prompt: return a friendly denial such as "config isn't available over Remote Control." and stop before querying.
- Let unknown or malformed slash text fall through as plain text rather than converting it into a new local error surface for remote users.
- Keep discovery aligned with execution by advertising only bridge-safe commands to remote clients whenever possible; the override should narrow execution, not widen the visible command set.

## Example Application
A mobile bridge sends `/deploy-docs`. The bridge layer parses it locally, confirms it is on the remote-safe allowlist, and then hands it to normal slash-command execution. The same bridge sends `/config`; the command resolves but is not remote-safe, so the system responds locally with a denial message. If the bridge sends `/shrug` and that text does not resolve to a known command, it stays plain text and is handled like an ordinary message.

## Anti-Patterns (What NOT to do)
- Do not disable slash skipping for all bridge traffic up front; that reopens the exact remote-command surface the default suppression was meant to close.
- Do not pass known unsafe slash commands through as ordinary model text; the model should not have to interpret config after local policy already knows it is disallowed remotely.
- Do not reject unknown bridge slash text with a new "Unknown skill" style error; preserving plain-text fallback avoids breaking ordinary remote messages that happen to start with `/`.
