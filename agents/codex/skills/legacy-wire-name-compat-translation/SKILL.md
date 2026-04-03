---
name: legacy-wire-name-compat-translation
description: "Translate renamed internal identifiers back to their legacy wire names at serialization boundaries so patch-level consumers keep working until the planned version cutoff."
metadata:
  author: ychampion
---

# SKILL: Legacy Wire Name Compat Translation
**Domain:** wire-compatibility
**Trigger:** Apply when an internal tool, command, or capability identifier has been renamed, but existing SDK or UI consumers still depend on the old wire name and cannot safely break on a patch release.
**Source Pattern:** Distilled from reviewed remote-control, bridge transport, and capability-advertising implementations.

## Core Method
Keep the renamed identifier as the canonical internal name, then insert a narrow compatibility translator at the wire boundary that maps the new internal identifier back to the legacy external name before emitting payloads. Scope the translation to the specific renamed symbols that already escaped into client contracts, and keep it in place only until the explicitly planned version boundary where a breaking change is allowed. This preserves internal clarity and forward migration work without surprising patch-level consumers that still parse the legacy wire label.

## Key Rules
- Translate at serialization time, not throughout business logic; the new identifier should remain canonical inside the codebase.
- Limit the mapping to the externally contracted names that actually changed, so unrelated identifiers keep flowing through untouched.
- Reuse one compatibility helper anywhere the wire payload is emitted, otherwise different event types or transports will drift and expose mixed names.
- Tie the shim to an explicit removal boundary such as the next minor or major release, and document that boundary next to the translator so the temporary contract does not become accidental forever behavior.
- Preserve stable wire names across both discovery and result surfaces when clients observe both; partial translation still breaks consumers that correlate the same capability across messages.

## Example Application
If a product renames an internal tool from `Task` to `Agent`, keep `Agent` as the implementation name but translate it back to `Task` in init and result payloads until the next planned minor release. SDK clients that were built against the old wire contract continue to function, while the codebase and future migration work use the new canonical identifier internally.

## Anti-Patterns (What NOT to do)
- Do not immediately emit the renamed identifier on a patch release just because the internal refactor is complete; external wire contracts have a different compatibility bar than internal names.
- Do not scatter if old name branches across core logic to preserve compatibility; isolate the translation at the boundary.
- Do not update only one payload type and leave others on the new name; mixed-wire naming is still a contract break for consumers that join data across events.
