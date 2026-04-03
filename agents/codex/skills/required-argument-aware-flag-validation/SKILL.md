---
name: required-argument-aware-flag-validation
description: "Walk command tokens while inspecting attached/inline arguments so validators never skip missing or dangerous flag values."
metadata:
  author: ychampion
---

# SKILL: Required Argument Aware Flag Validation
**Domain:** validator
**Trigger:** Apply this whenever flag validation cannot rely on shell parsers and must check `--flag=value`, combined short bundles, and missing arguments explicitly.
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Iterate over tokens after the command verb, treat `--` according to whether the tool respects it, then inspect each `-flag`/`--flag` by looking it up in the declarative config. Handle inline values (`-E=`), attached numeric args (`-A20`), and bundles of non-arg flags carefully: reject unknown flags, ensure required arguments exist, and forbid bundles that include arg-taking options. Use typed helpers (validate flag argument) to keep regex/number checks centralized.

## Key Rules
- Never assume an inline assignment contains a value; `--flag=` must be validated as empty input, not allowed to silently consume the next token.
- For launcher commands such as `xargs`, stop validating wrapper flags once parsing has switched to the downstream command.
- Reject combined short flags if any member expects an argument; allow only `none`-type flags in bundles to avoid parser differentials.
- Guard string arguments from starting with `-` unless the flag explicitly allows it (e.g., `git --sort -version:refname`).

## Example Application
Implement this in a shell command policy layer by validating the tokenized command against declarative flag metadata before execution. That ensures commands containing `-S`, `--diff-filter`, or `--flag=value` cannot bypass read-only guardrails through parser edge cases.

## Anti-Patterns (What NOT to do)
- Do not treat `-FLAG=value` the same as `-FLAG value`; the attached format still needs its own validation rules.
- Do not skip the empty-inline-value check for `-FLAG=`; otherwise attackers can bypass restrictions by hiding invalid input behind `=`.
