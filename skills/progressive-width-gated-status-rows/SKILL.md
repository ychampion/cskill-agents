---
name: progressive-width-gated-status-rows
description: "Show status metadata only when the spinner row has room, shrinking entries as viewport width decreases."
metadata:
  author: ychampion
---

# SKILL: Progressive Width Gated Status Rows
**Domain:** status-rows
**Trigger:** Apply this when terminal status rows need to show token counters, timers, and thinking text but must drop elements as available width shrinks.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Treat the spinner row as three segments (timer, tokens, thinking) and calculate their widths against the current column count every animation frame. Start with the high-priority spinner glyph plus message, then gate the timer/tokens/thinking segments one by one: if there isn’t enough remaining width, drop the lowest-priority segment, and shrink the thinking text to a bare “thinking” label before giving up on showing it. Recompute using memoized string widths and reuse the shared animation clock so the gating logic runs only while the spinner is active.

## Key Rules
- Derive available space by subtracting the stable spinner glyph+message width from the terminal columns count; use that budget to decide which segments stay.
- Prioritize segments: always keep the timer and tokens before thinking text, and only show thinking text when `columns` exceeds the sum of higher-priority segments.
- When thinking text is “thinking” with effort suffix, shrink it to just “thinking” before hiding to avoid measuring long strings repeatedly.
- Use the shared 50ms animation frame to update gating decisions so the outer spinner container can remain stable and offscreen components stay frozen.

## Example Application
In a CLI showing tool outputs plus spinner, follow this skill by measuring string width for each segment and gating tokens/timers per frame, ensuring the row never wraps or pushes subsequent lines on narrow terminals.

## Anti-Patterns (What NOT to do)
- Don’t wrap the entire row anytime the viewport narrows; the spinner should breathe but not push other elements down.
- Don’t re-render the spinner tree just to compute width; keep gating logic inside the animation loop and memoize widths to avoid extra layout churn.
