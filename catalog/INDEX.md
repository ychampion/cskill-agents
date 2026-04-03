# Curated Skill Index

This repo ships 84 curated skills selected for building or improving agentic coding CLIs, terminal tools, and multi-agent runtimes.

## Starter Bundle

- [Portable Skill Loader Progressive Disclosure](../skills/portable-skill-loader-progressive-disclosure/SKILL.md): Keep the universal skill compact yet discoverable by loading minimal frontmatter first and heavy content on demand.
- [Project-Root Scoped Local Skill Loading](../skills/project-root-scoped-local-skill-loading/SKILL.md): Resolve a stable project root first, then load local skills relative to that scope before combining them with other sources.
- [Memoized Command Source Aggregation](../skills/memoized-command-source-aggregation/SKILL.md): Load independent command sources in parallel, then memoize the merged registry by cwd so repeated lookups stay cheap and ordered.
- [Feature-Gated Command Registry Loading](../skills/feature-gated-command-registry-loading/SKILL.md): Gate optional command modules behind lazy feature checks so disabled features do not inflate startup or registry cost.
- [Lazy Heavy Command Shims](../skills/lazy-heavy-command-shims/SKILL.md): Keep heavyweight commands discoverable through lightweight shims that import the real implementation only on execution.
- [Dynamic Skill Insertion Before Builtins](../skills/dynamic-skill-insertion-before-builtins/SKILL.md): Merge runtime-discovered commands into an existing command registry by deduping them against the enabled base surface and inserting them at a stable boundary before built-in commands.
- [Layered Command Cache Invalidation](../skills/layered-command-cache-invalidation/SKILL.md): Clear every memoized layer in a command or skill pipeline so dynamic updates invalidate outer derived views as well as inner source caches.
- [Descriptive Skill Surface Admission](../skills/descriptive-skill-surface-admission/SKILL.md): Use source-aware admission rules so trusted local skills can surface automatically while plugin or MCP-provided entries must supply explicit descriptive metadata.
- [Bundled-and-MCP Turn-Zero Skill Filter](../skills/bundled-and-mcp-turn-zero-skill-filter/SKILL.md): Shrink first-turn skill listings to bundled and MCP-backed high-signal sources, with a deterministic bundled-only fallback if still too large.
- [Concurrency-Safe Tool Batching](../skills/concurrency-safe-tool-batching/SKILL.md): Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work.
- [Ordered Streaming Tool Execution](../skills/ordered-streaming-tool-execution/SKILL.md): Buffer and execute streaming tool calls with concurrency awareness so results appear in request order even when multiple runners overlap.
- [Progress-First Tool Emission](../skills/progress-first-tool-emission/SKILL.md): Emit progress/value updates as soon as they arrive while still buffering final results and handling cancellations or sibling errors.
- [Required Argument Aware Flag Validation](../skills/required-argument-aware-flag-validation/SKILL.md): Walk command tokens while inspecting attached/inline arguments so validators never skip missing or dangerous flag values.
- [Idempotent Tool Result Persistence](../skills/idempotent-tool-result-persistence/SKILL.md): Persist tool results once, avoid re-writing duplicates, and summarize via previews so long outputs stay accessible yet capped.
- [Conversation Engine Persistent Session State](../skills/conversation-engine-persistent-session-state/SKILL.md): Keep session-level signals (messages, read caches, memory loads) alive across turns while letting per-turn caches reset for correctness.
- [API Round Message Grouping](../skills/api-round-message-grouping/SKILL.md): Split conversation history into API-round buckets so compaction retries cut only the chunks tied to the failed round.
- [Autocompact Circuit Breaker](../skills/autocompact-circuit-breaker/SKILL.md): Break the autocompact retry loop after several consecutive failures to avoid hammering shared APIs.
- [Largest First Context Shedding](../skills/largest-first-context-shedding/SKILL.md): Reduce over-budget messages by persisting the largest fresh tool results first while leaving smaller or already-frozen blocks inline.
- [Reserved Summary Output Budget](../skills/reserved-summary-output-budget/SKILL.md): Reserve part of the context window for summary output so proactive compaction does not kill the response budget.
- [Token Budgeted Compaction With Reinjection](../skills/token-budgeted-compaction-with-reinjection/SKILL.md): Keep compaction budgets under control by compacting incrementally and reinjecting truncated attachments only when the reasoning surface remains stable.
- [Turn-Scoped Memory Prefetch with Disposal](../skills/turn-scoped-memory-prefetch-with-disposal/SKILL.md): Start a non-blocking, turn-scoped memory prefetch that auto-disposes and only injects results once per turn.
- [Session Memory First Compaction](../skills/session-memory-first-compaction/SKILL.md): Try lightweight session-memory summaries before falling back to heavyweight full-conversation compaction.
- [Additive Agent Tool Surface Construction](../skills/additive-agent-tool-surface-construction/SKILL.md): Merge agent-specific tool sets (MCP clients + fetched tools) into the parent context without disrupting the parent’s existing pool.
- [Permission Overlay Inheritance](../skills/permission-overlay-inheritance/SKILL.md): Layer child permission rules over parent session policy without dropping root-level grants or mutating shared state.
- [Forked Auto Memory Extraction](../skills/forked-auto-memory-extraction/SKILL.md): Run memory harvesting in a fenced background agent after the main turn so the primary loop stays responsive.
- [Lifecycle-Scoped Resource Cleanup](../skills/lifecycle-scoped-resource-cleanup/SKILL.md): Release every resource allocated to a child agent inside one unconditional cleanup path so finished or aborted runs leave no lingering hooks, watchers, or background jobs.
- [Fast Worktree Reuse With Head Pointer Checks](../skills/fast-worktree-reuse-with-head-pointer-checks/SKILL.md): Resume existing worktrees quickly by checking stored HEAD pointers before fetching or recreating.
- [Declarative Read Only Command Allowlists](../skills/declarative-read-only-command-allowlists/SKILL.md): Express shell-command safety as declarative flag maps so tooling knows exactly what passes.
- [Plan Mode Permission Gating](../skills/plan-mode-permission-gating/SKILL.md): Enter plan mode through an explicit permission transition that enforces a no-edit planning state before implementation.
- [Remote Safe Command Allowlist](../skills/remote-safe-command-allowlist/SKILL.md): Define a narrow explicit set of commands that stay available in remote mode because they only affect local UI state, then reuse that set at startup and after handshake refinement.
- [Bridge Origin Safe Slash Override](../skills/bridge-origin-safe-slash-override/SKILL.md): Keep remote slash-command skipping enabled by default, then reopen it only for bridge-safe commands while denying unsafe local commands with a friendly local response.
- [Shared System Init Shape Parity](../skills/shared-system-init-shape-parity/SKILL.md): Centralize `system/init` or capability payload construction in one builder so multiple transports emit identical schemas and only vary inputs or delivery.
- [Privacy-Redacted REPL Bridge System Init](../skills/privacy-redacted-repl-bridge-system-init/SKILL.md): Reuse one `system/init` payload shape across trusted and remote transports, but redact tool, MCP, and plugin metadata when the bridge path would leak local integrations or filesystem paths.
- [ANSI-Safe Border Caption Embedding](../skills/ansi-safe-border-caption-embedding/SKILL.md): Embed captions into terminal borders while preserving alignment, clipping, and color/dim semantics.
- [Wrapped Text Style Preservation](../skills/wrapped-text-style-preservation/SKILL.md): Track per-character segments so wrapped or truncated text keeps its original colors and emphasis.
- [Capability Based Spinner Glyph Selection](../skills/capability-based-spinner-glyph-selection/SKILL.md): Select spinner glyphs and colors dynamically based on terminal capability, motion preference, and stall state.

## By Category

### Command Surfaces

Skills for command registries, skill admission, discovery, and capability surfaces.

- [Budget-Aware Skill Listing Formatting](../skills/budget-aware-skill-listing-formatting/SKILL.md): Derive the active model context budget at runtime and format skill listings to fit it instead of emitting raw command sets.
- [Bundled-and-MCP Turn-Zero Skill Filter](../skills/bundled-and-mcp-turn-zero-skill-filter/SKILL.md): Shrink first-turn skill listings to bundled and MCP-backed high-signal sources, with a deterministic bundled-only fallback if still too large.
- [Descriptive Skill Surface Admission](../skills/descriptive-skill-surface-admission/SKILL.md): Use source-aware admission rules so trusted local skills can surface automatically while plugin or MCP-provided entries must supply explicit descriptive metadata.
- [Dynamic Skill Insertion Before Builtins](../skills/dynamic-skill-insertion-before-builtins/SKILL.md): Merge runtime-discovered commands into an existing command registry by deduping them against the enabled base surface and inserting them at a stable boundary before built-in commands.
- [Feature-Gated Command Registry Loading](../skills/feature-gated-command-registry-loading/SKILL.md): Gate optional command modules behind lazy feature checks so disabled features do not inflate startup or registry cost.
- [Initial-vs-Dynamic Skill Listing Batching](../skills/initial-vs-dynamic-skill-listing-batching/SKILL.md): Mark first-time skill listings differently from later deltas so consumers can treat bootstrap exposure and updates separately.
- [Layered Command Cache Invalidation](../skills/layered-command-cache-invalidation/SKILL.md): Clear every memoized layer in a command or skill pipeline so dynamic updates invalidate outer derived views as well as inner source caches.
- [Lazy Heavy Command Shims](../skills/lazy-heavy-command-shims/SKILL.md): Keep heavyweight commands discoverable through lightweight shims that import the real implementation only on execution.
- [Local-and-MCP Skill Name Deduplication](../skills/local-and-mcp-skill-name-deduplication/SKILL.md): Merge local and MCP skill sources into one listing surface and dedupe by stable command name before announcing them.
- [Memoized Command Source Aggregation](../skills/memoized-command-source-aggregation/SKILL.md): Load independent command sources in parallel, then memoize the merged registry by cwd so repeated lookups stay cheap and ordered.
- [Portable Skill Loader Progressive Disclosure](../skills/portable-skill-loader-progressive-disclosure/SKILL.md): Keep the universal skill compact yet discoverable by loading minimal frontmatter first and heavy content on demand.
- [Project-Root Scoped Local Skill Loading](../skills/project-root-scoped-local-skill-loading/SKILL.md): Resolve a stable project root first, then load local skills relative to that scope before combining them with other sources.
- [Slash-Command Skill Classification Filter](../skills/slash-command-skill-classification-filter/SKILL.md): Derive a slash-command skill surface from a broader prompt-command registry by requiring descriptive metadata, excluding builtins, and admitting only a controlled set of origins plus explicit user-only commands.
- [Turn-Zero vs Inter-Turn Skill Discovery Split](../skills/turn-zero-vs-inter-turn-skill-discovery-split/SKILL.md): Block only the first discovery pass, then overlap later discovery with tool execution so streaming turns stay responsive.

### Tool Orchestration

Skills for tool batching, streaming, validation, persistence, and output shaping.

- [Capability Pool Resolution](../skills/capability-pool-resolution/SKILL.md): Resolve an agent’s tool intent and disallowed lists into the actual pool the agent can use, honoring wildcard, async, and teammate allowances.
- [Circular-Safe Tool Registry Loading](../skills/circular-safe-tool-registry-loading/SKILL.md): Safely assemble the tool registry when optional tools have circular dependencies or heavy side effects.
- [Concurrency-Safe Tool Batching](../skills/concurrency-safe-tool-batching/SKILL.md): Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work.
- [Decision Fate Freezing](../skills/decision-fate-freezing/SKILL.md): Freeze each tool result ID's replacement fate after it is observed so budget decisions stay deterministic across turns and forks.
- [Idempotent Tool Result Persistence](../skills/idempotent-tool-result-persistence/SKILL.md): Persist tool results once, avoid re-writing duplicates, and summarize via previews so long outputs stay accessible yet capped.
- [Modality-Preserving Binary Offload](../skills/modality-preserving-binary-offload/SKILL.md): Persist binary output with a mime-derived extension and a matching saved-file message so downstream tools keep the right modality.
- [Ordered Streaming Tool Execution](../skills/ordered-streaming-tool-execution/SKILL.md): Buffer and execute streaming tool calls with concurrency awareness so results appear in request order even when multiple runners overlap.
- [Progress-First Tool Emission](../skills/progress-first-tool-emission/SKILL.md): Emit progress/value updates as soon as they arrive while still buffering final results and handling cancellations or sibling errors.
- [Required Argument Aware Flag Validation](../skills/required-argument-aware-flag-validation/SKILL.md): Walk command tokens while inspecting attached/inline arguments so validators never skip missing or dangerous flag values.
- [Tail-Preserving Task Output Truncation](../skills/tail-preserving-task-output-truncation/SKILL.md): Persist tool outputs alongside metadata and truncate only the preview, ensuring the header points back to the persisted replica.
- [Wire-Shape Aligned Budgeting](../skills/wire-shape-aligned-budgeting/SKILL.md): Keep each wire message’s aggregate tool_result size within the configured budget by compacting the largest fresh results first.

### Context Management

Skills for compaction, memory fetch, retry control, and long-running session stability.

- [API Round Message Grouping](../skills/api-round-message-grouping/SKILL.md): Split conversation history into API-round buckets so compaction retries cut only the chunks tied to the failed round.
- [API-Round PTL Retry Truncation](../skills/api-round-ptl-retry-truncation/SKILL.md): On prompt-too-long retries, drop the oldest API-round groups first and inject a synthetic user preamble when needed so the summarize request stays valid.
- [Autocompact Circuit Breaker](../skills/autocompact-circuit-breaker/SKILL.md): Break the autocompact retry loop after several consecutive failures to avoid hammering shared APIs.
- [Autocompact Recursion Guards](../skills/autocompact-recursion-guards/SKILL.md): Block autocompact from running in recursive contexts so forks and helpers don’t deadlock.
- [Cache Edit Pin and Replay](../skills/cache-edit-pin-and-replay/SKILL.md): Queue cache edits once, pin them to message positions, and replay them across turns instead of regenerating them on every retry.
- [Compactable Tool Whitelist Gating](../skills/compactable-tool-whitelist-gating/SKILL.md): Only allow cached microcompact to delete tool results for a vetted, pre-gated whitelist of tool names.
- [Conversation Engine Persistent Session State](../skills/conversation-engine-persistent-session-state/SKILL.md): Keep session-level signals (messages, read caches, memory loads) alive across turns while letting per-turn caches reset for correctness.
- [Largest First Context Shedding](../skills/largest-first-context-shedding/SKILL.md): Reduce over-budget messages by persisting the largest fresh tool results first while leaving smaller or already-frozen blocks inline.
- [Progressive Compaction Prompt](../skills/progressive-compaction-prompt/SKILL.md): Drive compaction summaries through structured prompts that sequence naming, artifacts, and invocation guidance before stripping analysis tags.
- [Relevant Memory Selection By Header](../skills/relevant-memory-selection-by-header/SKILL.md): Rank memory files by header descriptions so only a small high-signal subset is injected back into context.
- [Reserved Summary Output Budget](../skills/reserved-summary-output-budget/SKILL.md): Reserve part of the context window for summary output so proactive compaction does not kill the response budget.
- [Session Memory First Compaction](../skills/session-memory-first-compaction/SKILL.md): Try lightweight session-memory summaries before falling back to heavyweight full-conversation compaction.
- [Time-Gap Cache-Expiry Microcompact](../skills/time-gap-cache-expiry-microcompact/SKILL.md): When a long idle gap means the server cache is cold, clear old tool-result content before the next request instead of attempting warm-cache cache edits.
- [Token Budgeted Compaction With Reinjection](../skills/token-budgeted-compaction-with-reinjection/SKILL.md): Keep compaction budgets under control by compacting incrementally and reinjecting truncated attachments only when the reasoning surface remains stable.
- [Turn-Scoped Memory Prefetch with Disposal](../skills/turn-scoped-memory-prefetch-with-disposal/SKILL.md): Start a non-blocking, turn-scoped memory prefetch that auto-disposes and only injects results once per turn.

### Multi-Agent

Skills for child agents, forked execution, permission inheritance, and lifecycle cleanup.

- [Additive Agent Tool Surface Construction](../skills/additive-agent-tool-surface-construction/SKILL.md): Merge agent-specific tool sets (MCP clients + fetched tools) into the parent context without disrupting the parent’s existing pool.
- [Agent-Specific MCP Server Initialization](../skills/agent-specific-mcp-server-initialization/SKILL.md): Connect each agent’s frontmatter MCP servers safely and tear them down without leaking clients, while honoring plugin-only guards.
- [Append-Only Sidechain Transcripts](../skills/append-only-sidechain-transcripts/SKILL.md): Persist subagent transcripts as an append-only ordered log so forks, resumes, and sidechain readers can replay history without duplication.
- [Built-In Agent Feature Gating](../skills/built-in-agent-feature-gating/SKILL.md): Expose built-in agents according to entrypoint, mode, and feature flags so each runtime gets the right built-in surface.
- [Cache Identical Fork Prefix Construction](../skills/cache-identical-fork-prefix-construction/SKILL.md): Build forked conversation prefixes that stay identical across turns so prompt caching keeps working.
- [Cache Prefix Stability For Subagents](../skills/cache-prefix-stability-for-subagents/SKILL.md): Preserve cache-critical request fields when a child agent must share the parent's prompt prefix for cache hits.
- [Fork Child Directive Guardrails](../skills/fork-child-directive-guardrails/SKILL.md): Keep fork-decoupled workers strictly bounded by directive text and cache sharing requirements.
- [Forked Auto Memory Extraction](../skills/forked-auto-memory-extraction/SKILL.md): Run memory harvesting in a fenced background agent after the main turn so the primary loop stays responsive.
- [Forked Skill Execution With Isolated Context](../skills/forked-skill-execution-with-isolated-context/SKILL.md): Run SkillTool slash commands inside a forked sub-agent so the skill has isolated budget, telemetry, and lifecycle.
- [Lifecycle-Scoped Resource Cleanup](../skills/lifecycle-scoped-resource-cleanup/SKILL.md): Release every resource allocated to a child agent inside one unconditional cleanup path so finished or aborted runs leave no lingering hooks, watchers, or background jobs.
- [Namespace-Resolved Skill Preloading](../skills/namespace-resolved-skill-preloading/SKILL.md): Resolve startup skill names through layered namespace lookup before preloading them as explicit visible context.
- [Orphaned Tool Call Sanitizer](../skills/orphaned-tool-call-sanitizer/SKILL.md): Remove assistant messages that reference tools without recorded results before feeding the history back into runAgent.
- [Permission Overlay Inheritance](../skills/permission-overlay-inheritance/SKILL.md): Layer child permission rules over parent session policy without dropping root-level grants or mutating shared state.
- [Subagent Metrics Bridging](../skills/subagent-metrics-bridging/SKILL.md): Connect async subagent streams to progress UI, analytics, and notifications from one finalized lifecycle snapshot.
- [Trusted Frontmatter Gating](../skills/trusted-frontmatter-gating/SKILL.md): Gate frontmatter MCP servers, hooks, and skills behind admin trust when plugin-only or hook-only modes are active.

### Extensions And MCP

Skills for extension reconciliation, MCP surfaces, and runtime activation.

- [Headless Interactive Reconcile Parity](../skills/headless-interactive-reconcile-parity/SKILL.md): Keep interactive and headless extension installation flows behaviorally aligned by sharing reconciliation logic and adapting only the outer contract.
- [MCP Skill vs Prompt Discovery Filtering](../skills/mcp-skill-vs-prompt-discovery-filtering/SKILL.md): Merge MCP-discovered prompt skills with local commands only after type filtering and name deduplication.
- [Plugin-Only Agent Surface Gating](../skills/plugin-only-agent-surface-gating/SKILL.md): Prevent untrusted agent definitions from expanding the MCP surface when the session is locked to plugin-only extensions.
- [Three-Layer Extension Sync](../skills/three-layer-extension-sync/SKILL.md): Model extension lifecycle as intent, materialization, and active runtime layers, then sync each layer with dedicated transitions.

### Safety And Worktrees

Skills for safe shell execution, path guards, worktree reuse, and repo safety.

- [Auto Memory Tool Permission Fencing](../skills/auto-memory-tool-permission-fencing/SKILL.md): Gate every tool call in the auto-memory extract agent so only safe read-only actions and targeted writes execute.
- [Canonical Worktree Path Normalization](../skills/canonical-worktree-path-normalization/SKILL.md): Resolve repo-relative paths against the canonical checkout root so shared state stays stable across Git worktrees.
- [Case-Normalized Sensitive Path Guards](../skills/case-normalized-sensitive-path-guards/SKILL.md): Normalize filesystem paths and reject matches that try to spoof sensitive directories with mixed case or alternate separators.
- [Cross Shell Command Safety Maps](../skills/cross-shell-command-safety-maps/SKILL.md): Describe how to centralize cross-platform safe commands, UNC detection, and per-shell path guards so every shell tool shares the same policy.
- [Dangerous Config File Protection](../skills/dangerous-config-file-protection/SKILL.md): Keep writes out of sensitive dotfiles and `.claude` folders by checking canonicalized basenames before granting permission.
- [Declarative Read Only Command Allowlists](../skills/declarative-read-only-command-allowlists/SKILL.md): Express shell-command safety as declarative flag maps so tooling knows exactly what passes.
- [Fast Worktree Reuse With Head Pointer Checks](../skills/fast-worktree-reuse-with-head-pointer-checks/SKILL.md): Resume existing worktrees quickly by checking stored HEAD pointers before fetching or recreating.
- [Plan Mode Permission Gating](../skills/plan-mode-permission-gating/SKILL.md): Enter plan mode through an explicit permission transition that enforces a no-edit planning state before implementation.
- [Remote Safe Command Allowlist](../skills/remote-safe-command-allowlist/SKILL.md): Define a narrow explicit set of commands that stay available in remote mode because they only affect local UI state, then reuse that set at startup and after handshake refinement.
- [Safe Worktree Slug Validation](../skills/safe-worktree-slug-validation/SKILL.md): Ensure Git worktree slugs can never escape the managed workspace or inject traversal.

### Remote And Bridge

Skills for remote-safe command surfaces, transport contracts, and bridge gating.

- [Bridge Origin Safe Slash Override](../skills/bridge-origin-safe-slash-override/SKILL.md): Keep remote slash-command skipping enabled by default, then reopen it only for bridge-safe commands while denying unsafe local commands with a friendly local response.
- [Bridge Safe Command Advertising](../skills/bridge-safe-command-advertising/SKILL.md): Advertise only slash commands that a bridge client can actually invoke by filtering announcements with the same bridge-safety predicate used at execution time.
- [Legacy Wire Name Compat Translation](../skills/legacy-wire-name-compat-translation/SKILL.md): Translate renamed internal identifiers back to their legacy wire names at serialization boundaries so patch-level consumers keep working until the planned version cutoff.
- [Nonblocking Post-Connect Capability Broadcast](../skills/nonblocking-post-connect-capability-broadcast/SKILL.md): Mark bridge sessions ready first, then send optional capability metadata asynchronously without delaying readiness.
- [Privacy-Redacted REPL Bridge System Init](../skills/privacy-redacted-repl-bridge-system-init/SKILL.md): Reuse one `system/init` payload shape across trusted and remote transports, but redact tool, MCP, and plugin metadata when the bridge path would leak local integrations or filesystem paths.
- [Shared System Init Shape Parity](../skills/shared-system-init-shape-parity/SKILL.md): Centralize `system/init` or capability payload construction in one builder so multiple transports emit identical schemas and only vary inputs or delivery.
- [Type Tiered Bridge Command Gating](../skills/type-tiered-bridge-command-gating/SKILL.md): Gate bridge-executed slash commands by command type first: block local-jsx UI commands, allow prompt commands by construction, and require an explicit allowlist for plain local commands.
- [User-Invocable Capability Serialization](../skills/user-invocable-capability-serialization/SKILL.md): Serialize announced command and skill surfaces from a shared capability shape, excluding entries explicitly marked non-user-invocable.

### Terminal UI

Skills for terminal presentation, status rows, captions, and motion-aware UI.

- [ANSI-Safe Border Caption Embedding](../skills/ansi-safe-border-caption-embedding/SKILL.md): Embed captions into terminal borders while preserving alignment, clipping, and color/dim semantics.
- [Capability Based Spinner Glyph Selection](../skills/capability-based-spinner-glyph-selection/SKILL.md): Select spinner glyphs and colors dynamically based on terminal capability, motion preference, and stall state.
- [Progressive Width Gated Status Rows](../skills/progressive-width-gated-status-rows/SKILL.md): Show status metadata only when the spinner row has room, shrinking entries as viewport width decreases.
- [Reduced-Motion First Terminal Animation](../skills/reduced-motion-first-terminal-animation/SKILL.md): Pause terminal animations when the user requests reduced motion, then resume cleanly without tearing the rest of the UI.
- [Scrollback Freeze Optimization](../skills/scrollback-freeze-optimization/SKILL.md): Cache and reuse animated children once they slide into scrollback so terminal resets never occur.
- [Viewport-Aware Animation Pausing](../skills/viewport-aware-animation-pausing/SKILL.md): Stop updating animation ticks as soon as the animated element leaves the viewport so scrollback never forces terminal resets.
- [Wrapped Text Style Preservation](../skills/wrapped-text-style-preservation/SKILL.md): Track per-character segments so wrapped or truncated text keeps its original colors and emphasis.
