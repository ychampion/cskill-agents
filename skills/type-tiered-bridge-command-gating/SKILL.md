---
name: type-tiered-bridge-command-gating
description: "Gate bridge-executed slash commands by command type first: block local-jsx UI commands, allow prompt commands by construction, and require an explicit allowlist for plain local commands."
metadata:
  author: ychampion
---

# SKILL: Type Tiered Bridge Command Gating
**Domain:** command-architecture
**Trigger:** Use when a remote or bridged client can invoke slash commands and you need a simple safety rule that separates text-expanding commands from local UI commands and plain local actions.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Classify bridge safety by command type before inspecting individual command names. Treat `local-jsx` commands as unsafe by construction because they render local UI, treat `prompt` commands as safe by construction because they only expand into model text, and apply a narrow explicit allowlist only to plain `local` commands. This creates a three-tier gate where only one class needs per-command review, so remote/mobile surfaces stay predictable and new command types inherit the right default behavior.

## Key Rules
- Put the type check first so the bridge gate does not need ad hoc per-command exceptions for UI-rendering commands.
- Block every `local-jsx` command by default; if a command depends on local Ink or terminal state, it should fail the bridge gate without consulting any allowlist.
- Allow `prompt` commands by type, since their output is text passed back into the model flow rather than a local side effect.
- Require explicit allowlist membership for plain `local` commands, making denial the default for any local command that has not been reviewed for remote execution.
- Keep the allowlist static and easy to audit so adding a new remotely safe local command is an intentional registry change, not an incidental side effect of command loading.

## Example Application
When a mobile client submits summary, model, and research, run the bridge gate on the resolved command objects. model is rejected immediately because it is `local-jsx`, research is admitted because it is `prompt`, and summary only passes if it appears in the reviewed `local` allowlist.

## Anti-Patterns (What NOT to do)
- Do not maintain one flat allowlist for every command type; that obscures why prompt commands are safe and makes UI commands easier to admit accidentally.
- Do not treat plain `local` commands as safe by default just because they stream text; bridge safety requires explicit review.
- Do not special-case individual `local-jsx` commands after the fact; the value of the pattern is that the type already encodes the unsafe class.
