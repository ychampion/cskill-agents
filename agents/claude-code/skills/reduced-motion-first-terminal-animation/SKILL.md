---
name: reduced-motion-first-terminal-animation
description: "Pause terminal animations when the user requests reduced motion, then resume cleanly without tearing the rest of the UI."
metadata:
  author: ychampion
---

# SKILL: Reduced-Motion First Terminal Animation
**Domain:** terminal-ui
**Trigger:** Build any animation that should stay dormant until the user explicitly opts into motion.
**Source Pattern:** Distilled from reviewed terminal rendering, layout, animation, and accessibility implementations.

## Core Method
Read the local reduced-motion preference before spawning timers and treat `null` as “paused.” Hook animations into a single clock that can unregister itself whenever the animation is hidden, so the loop never races multiple independent timers while respecting accessibility.

## Key Rules
- Evaluate get initial settings prefers reduced motion (or equivalent) on mount and refuse to start motion if true.
- Share one clock (e.g., use animation frame) so every animation breathes in sync and can be paused by passing `null`.
- Never queue set timeout when reduced motion or pause is active; return the last drawn frame instead.
- Resume from the current global time when motion becomes allowed again so there is no jump.

## Example Application
When animating a loading spinner in a toolbar, wire the spinner to the shared clock and keep it frozen until the user unsets prefers reduced motion; the rest of the layout retains its state, and the spinner returns to the proper frame without rewinding.

## Anti-Patterns (What NOT to do)
- Starting independent timers before checking reduced-motion and then canceling them later.
- Letting each animated component manage its own clock, which prevents pausing all motion with a single flag.
- Resetting animation timelines when motion resumes, which causes jarring jumps.
