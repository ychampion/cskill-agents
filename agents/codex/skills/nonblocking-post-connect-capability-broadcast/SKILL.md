---
name: nonblocking-post-connect-capability-broadcast
description: "Commit the connected state first, then gather optional capabilities and send a post-connect broadcast asynchronously without delaying readiness."
metadata:
  author: ychampion
---

# SKILL: Nonblocking Post-Connect Capability Broadcast
**Domain:** bridge-lifecycle
**Trigger:** Apply when a transport has reached its ready or connected state, but optional capability discovery and hello metadata still need to be broadcast to the remote peer.
**Source Pattern:** Distilled from reviewed bridge-lifecycle, capability-broadcast, and reconnect-flow implementations.

## Core Method
Treat connection visibility and capability advertisement as two separate phases. In the state-change handler, synchronously commit the host's connected/session-active flags first so the UI and downstream effects can react immediately. Only after that state commit should you launch a detached async task that resolves optional capabilities, re-checks cancellation or liveness, snapshots any current state needed for the payload, and sends the post-connect broadcast. Keep the late path best-effort: if capability loading or broadcast assembly fails, log it locally and leave the connection marked ready.

## Key Rules
- Commit the connected or session-active state before awaiting any optional capability load; readiness must not depend on slow skill or metadata discovery.
- Run the post-connect broadcast in fire-and-forget async work guarded by a local `try`/`catch` so failures do not bubble back into the connection transition.
- Re-check cancellation or handle liveness after the awaited capability work and before writing to the transport; the peer may already be gone.
- Read mutable payload state as late as practical inside the async task so the broadcast reflects the current permission mode, agents, or feature flags rather than a stale pre-await snapshot.
- Keep the broadcast path optional and feature-gated when the metadata is additive rather than required for connection correctness.

## Example Application
When a mobile or web client connects to a background bridge, flip the app state to `connected` immediately so forwarding and UI badges start right away. Then, in a detached async block, load the bridge-safe skill list, collect the latest runtime metadata, and send one `system/init` message. If that late load fails, record the error, but do not bounce the session back out of `connected`.

## Anti-Patterns (What NOT to do)
- Do not await capability discovery before setting the connected state; that turns optional metadata into user-visible connection latency.
- Do not clear or roll back the connected flag just because the late capability broadcast fails; the transport can still be healthy.
- Do not capture all payload state before the async work and reuse it blindly after awaits; you risk broadcasting stale session metadata.
