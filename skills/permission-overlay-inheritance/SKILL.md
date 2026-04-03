---
name: permission-overlay-inheritance
description: "Layer child permission rules over parent session policy without dropping root-level grants or mutating shared state."
metadata:
  author: ychampion
---

# SKILL: Permission Overlay Inheritance
**Domain:** permission-gating
**Trigger:** Apply when a subagent or nested workflow needs a narrower permission contract but must still inherit the parent session's top-level grants.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Start from the current app state, then derive a child-specific permission view by overlaying only the fields the child actually owns: permission mode, promptability flags, session-scoped allow rules, and effort level. Preserve parent bypass and SDK-level permissions so nested agents cannot accidentally weaken operator intent, and return the original state unchanged when no overlay is needed. This keeps permission inheritance explicit, composable, and side-effect-free.

## Key Rules
- Treat the parent permission context as the base contract; never mutate it in place when preparing a child view.
- Allow child permission modes only when they do not override stronger parent modes like bypass permissions or accept edits.
- Preserve root or CLI-supplied allow rules while replacing only the session-scoped rules the child explicitly owns.
- Derive prompt-suppression flags from runtime reality, such as async execution or an explicit can show permission prompts override.

## Example Application
If a background review agent should only use `Read` and `Grep` while the main session still has broader CLI-granted access, build its permission context as an overlay so the child narrows its own session rules without discarding the root-level contract.

## Anti-Patterns (What NOT to do)
- Do not copy the parent permission object and then mutate shared references; later agents will inherit unintended changes.
- Do not wipe all inherited allow rules when a child provides allowed tools; preserve the parent layer that came from explicit operator input.
