---
name: scrollback-freeze-optimization
description: "Cache and reuse animated children once they slide into scrollback so terminal resets never occur."
metadata:
  author: ychampion
---

# SKILL: Scrollback Freeze Optimization
**Domain:** terminal-ui
**Trigger:** Apply whenever you render active widgets that can scroll into terminal history and would otherwise force full-screen updates.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Wrap any timer-driven subtree with a viewport-aware container that caches the last visible React element in a ref. When the viewport reports hidden, always return the cached node instead of the live children; React's diffing sees no change and the terminal renderer skips the expensive full-screen redraw.

## Key Rules
- Use use terminal viewport to watch is visible and keep an explicit ref for the last rendered children.
- Only update the cache when the element is visible; otherwise return cached current so React reuses the reference.
- Disable memoization on the freeze wrapper (explicit `'use no memo'`) so React doesn't bail out before the cached reference is read.
- Keep the cached node simple so it can be safely reused after long pauses and still produce the correct layout.

## Example Application
Wrap a spinner in scrollback with the freeze wrapper so once you scroll past it, log-update never touches the spinner subtree even though its timer continues running when visible.

## Anti-Patterns (What NOT to do)
- Let the spinner still re-render while offscreen, which triggers repeated full-screen resets.
- Put the cache update inside a memoized component that never reads the cached ref.
- Assume scrollback nodes can simply be hidden with CSS; the terminal renderer still re-renders them.
