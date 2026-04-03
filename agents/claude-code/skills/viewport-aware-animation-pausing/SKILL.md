---
name: viewport-aware-animation-pausing
description: "Stop updating animation ticks as soon as the animated element leaves the viewport so scrollback never forces terminal resets."
metadata:
  author: ychampion
---

# SKILL: Viewport-Aware Animation Pausing
**Domain:** terminal-ui
**Trigger:** Use when terminal animations should stop updating as soon as they scroll out of view, so hidden widgets do not keep forcing redraws.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Attach each animated widget to visibility state from the terminal viewport. Drive animation ticks only while the widget is actually visible, and freeze the last rendered frame when it scrolls out of view. When the widget becomes visible again, resume from the cached frame instead of recomputing hidden updates. This keeps scrollback stable and avoids unnecessary full-screen resets.

## Key Rules
- Derive visibility from the animation container itself, not from a global assumption that the whole screen is visible.
- Stop scheduling animation frames while the widget is hidden, then resume cleanly when it returns.
- Cache the last rendered frame while hidden so the UI can reuse a stable subtree instead of repainting needlessly.
- Keep viewport visibility and animation scheduling aligned so hidden widgets never force redraw work.

## Example Application
For any animated mascot inside a scrollable log, hook the animation container to the viewport hook and deliver the cached subtree when the log scrolls past it; the animation silently stops while the user scrolls and picks up exactly where it left off.

## Anti-Patterns (What NOT to do)
- Continuing to update the shared clock after the animation leaves the viewport.
- Recreating new React elements on each render while the component is hidden, which defeats the freeze optimization.
- Depend on global periodic timers that run even when the widget is out of view.
