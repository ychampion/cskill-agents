---
name: ansi-safe-border-caption-embedding
description: "Embed captions into terminal borders while preserving alignment, clipping, and color/dim semantics."
metadata:
  author: ychampion
---

# SKILL: ANSI-Safe Border Caption Embedding
**Domain:** output-rendering
**Trigger:** Apply when you must insert text into a border line (top or bottom) while preserving the border characters, colors, and alignment, even if the caption is wider than available space.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Treat the border as a sequence of uniformly repeated characters, compute the textual width, and trim or center the caption before joining it back into the border; this keeps the corners intact. Use the helper that calculates string width (respecting wide characters), convert `position` into an absolute column, and split the border into before/text/after fragments so colors/dim states can be reapplied independently.

## Key Rules
- Always compute string width on the caption and the border to avoid breaking wide glyphs when aligning.
- Guard with max width: if text length border length 2, cut the caption so it fits without overwriting corner glyphs.
- Reapply color/dim styling separately to the prefix, caption, and suffix before writing to the output buffer so ANSI escapes stay symmetric.
- Support `start`, `end`, and `center` alignments plus `offset` adjustments so captions can hug either edge without manual math.

## Example Application
When labeling a dialog border, call this method with `position:'top'`, `align:'center'`, and the pre-rendered caption string; clip it if the window narrows, and keep the corner and side glyphs in place so the divider stays crisp.

## Anti-Patterns (What NOT to do)
- Do not blur characters by writing the caption directly into the border string without recalculating width; wide glyphs will be truncated incorrectly.
- Do not drop color/dim styling while embedding text, which makes the caption disappear under multi-colored borders.
