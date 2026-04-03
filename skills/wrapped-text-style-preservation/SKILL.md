---
name: wrapped-text-style-preservation
description: "Track per-character segments so wrapped or truncated text keeps its original colors and emphasis."
metadata:
  author: ychampion
---

# SKILL: Wrapped Text Style Preservation
**Domain:** terminal-ui
**Trigger:** When you must wrap or truncate a styled text run but cannot afford to lose per-segment colors, links, or emphasis, especially inside terminals that split lines at wrap boundaries.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Before wrapping, convert the styled segments into a char to segment map so each output character still references its originating segment. After wrapping with wrap text, walk the wrapped lines and reapply the original segment colors by mapping the wrapped character index back into the segment list; skip whitespace that was trimmed when `wrap` is in trim mode so you don’t leak palette data.

## Key Rules
- Build the char to segment map by expanding each segment’s length so wrapped characters keep their source index.
- When the wrapping algorithm trims whitespace (trim enabled), skip the trimmed chars rather than reapplying styles, because the final output no longer contains them.
- Reapply styles with apply text styles using the mapped segment data so bold/italic/underline/inverse remain consistent despite line breaks.
- Guard for wide characters by using string width or squash text nodes to segments to maintain alignment before reapplying colors.

## Example Application
Render a paragraph where each sentence is a different color link: wrap the paragraph via the existing renderer, then use the char-to-segment map to repaint each wrapped character, ensuring the link color and underline persist even though the text spans multiple lines.

## Anti-Patterns (What NOT to do)
- Do not re-wrap text and discard the original style metadata, which causes color resets at each line break.
- Do not assume trimmed whitespace should inherit a style; the output no longer contains those glyphs, so touching them reintroduces invisible spans.
