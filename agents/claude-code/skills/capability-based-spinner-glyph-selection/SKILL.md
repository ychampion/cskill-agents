---
name: capability-based-spinner-glyph-selection
description: "Select spinner glyphs and colors dynamically based on terminal capability, motion preference, and stall state."
metadata:
  author: ychampion
---

# SKILL: Capability Based Spinner Glyph Selection
**Domain:** spinner-states
**Trigger:** Use when building a spinner glyph that must adapt to reduced-motion settings, theme colors, and stalled intensity while keeping the animation loop small.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Build the spinner glyph as a small composable component that decides on its character set and color per frame rather than swapping the whole spinner. Keep the spinner polymorphic: one glyph for the normal cycle, a single-dot fallback under reduced-motion, and an interpolated color path when the state is stalled. Have the component recompute only what changed (glyph, color, dimming flag) so the Ink renderer can reuse cached Box/Text nodes.

## Key Rules
- Drive the glyph selection from shared state (frame count, reduced-motion flag, stall intensity) and avoid new timers per spinner.
- Only swap glyphs/text nodes when the computed glyph, color, or reduced-motion dim state differs from the cached values.
- Interpolate colors through the theme lookup when stall intensity is positive; fall back to semantic names such as `error` if the RGB parse fails.
- Provide a single-dot glyph for reduced-motion and let dimColor toggle per half-cycle so motion is still perceivable without rapid frames.

## Example Application
When writing a database CLI spinner, reuse this skill by feeding the shared 50ms clock, the stalledIntensity derived from tool activity, and the host theme, and let the spinner component pick a glyph and color per frame instead of re-rendering the entire line.

## Anti-Patterns (What NOT to do)
- Don’t hardcode a single glyph or color and rerender the whole spinner on every frame.
- Don’t duplicate the timer logic inside each spinner; share the clock and only recompute derived glyph/color values when the inputs change.
