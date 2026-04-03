# Curated Skill Index

This repo ships 67 curated skills selected for building or improving agentic coding CLIs, terminal tools, and multi-agent runtimes.

## Starter Bundle

- [Portable Skill Loader Progressive Disclosure](../skills/portable-skill-loader-progressive-disclosure/SKILL.md): Keep the universal skill compact yet discoverable by loading minimal frontmatter first and heavy content on demand.
- [Project-Root Scoped Local Skill Loading](../skills/project-root-scoped-local-skill-loading/SKILL.md): Resolve a stable project root first, then load local skills relative to that scope before combining them with other sources.
- [Memoized Command Source Aggregation](../skills/memoized-command-source-aggregation/SKILL.md): Load independent command sources in parallel, then memoize the merged registry by cwd so repeated lookups stay cheap and ordered.
- [Dynamic Skill Insertion Before Builtins](../skills/dynamic-skill-insertion-before-builtins/SKILL.md): Merge runtime-discovered commands into an existing command registry by deduping them against the enabled base surface and inserting them at a stable boundary before built-in commands.
- [Layered Command Cache Invalidation](../skills/layered-command-cache-invalidation/SKILL.md): Clear every memoized layer in a command or skill pipeline so dynamic updates invalidate outer derived views as well as inner source caches.
- [Descriptive Skill Surface Admission](../skills/descriptive-skill-surface-admission/SKILL.md): Use source-aware admission rules so trusted local skills can surface automatically while plugin or MCP-provided entries must supply explicit descriptive metadata.
- [Concurrency-Safe Tool Batching](../skills/concurrency-safe-tool-batching/SKILL.md): Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work.
- [Ordered Streaming Tool Execution](../skills/ordered-streaming-tool-execution/SKILL.md): Buffer and execute streaming tool calls with concurrency awareness so results appear in request order even when multiple runners overlap.
- [Progress-First Tool Emission](../skills/progress-first-tool-emission/SKILL.md): Emit progress/value updates as soon as they arrive while still buffering final results and handling cancellations or sibling errors.
- [Required Argument Aware Flag Validation](../skills/required-argument-aware-flag-validation/SKILL.md): Walk command tokens while inspecting attached/inline arguments so validators never skip missing or dangerous flag values.
- [Idempotent Tool Result Persistence](../skills/idempotent-tool-result-persistence/SKILL.md): Persist tool results once, avoid re-writing duplicates, and summarize via previews so long outputs stay accessible yet capped.
- [Conversation Engine Persistent Session State](../skills/conversation-engine-persistent-session-state/SKILL.md): Keep session-level signals (messages, read caches, memory loads) alive across turns while letting per-turn caches reset for correctness.
- [API Round Message Grouping](../skills/api-round-message-grouping/SKILL.md): Split conversation history into API-round buckets so compaction retries cut only the chunks tied to the failed round.
- [Autocompact Circuit Breaker](../skills/autocompact-circuit-breaker/SKILL.md): Break the autocompact retry loop after several consecutive failures to avoid hammering shared APIs.
- [Reserved Summary Output Budget](../skills/reserved-summary-output-budget/SKILL.md): Reserve part of the context window for summary output so proactive compaction does not kill the response budget.
- [Token Budgeted Compaction With Reinjection](../skills/token-budgeted-compaction-with-reinjection/SKILL.md): Keep compaction budgets under control by compacting incrementally and reinjecting truncated attachments only when the reasoning surface remains stable.
- [Turn-Scoped Memory Prefetch with Disposal](../skills/turn-scoped-memory-prefetch-with-disposal/SKILL.md): Start a non-blocking, turn-scoped memory prefetch that auto-disposes and only injects results once per turn.
- [Additive Agent Tool Surface Construction](../skills/additive-agent-tool-surface-construction/SKILL.md): Merge agent-specific tool sets (MCP clients + fetched tools) into the parent context without disrupting the parent’s existing pool.
- [Permission Overlay Inheritance](../skills/permission-overlay-inheritance/SKILL.md): Layer child permission rules over parent session policy without dropping root-level grants or mutating shared state.
- [Lifecycle-Scoped Resource Cleanup](../skills/lifecycle-scoped-resource-cleanup/SKILL.md): Release every resource allocated to a child agent inside one unconditional cleanup path so finished or aborted runs leave no lingering hooks, watchers, or background jobs.
- [Fast Worktree Reuse With Head Pointer Checks](../skills/fast-worktree-reuse-with-head-pointer-checks/SKILL.md): Resume existing worktrees quickly by checking stored HEAD pointers before fetching or recreating.
- [Declarative Read Only Command Allowlists](../skills/declarative-read-only-command-allowlists/SKILL.md): Express shell-command safety as declarative flag maps so tooling knows exactly what passes.
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

- [Portable Skill Loader Progressive Disclosure](../skills/portable-skill-loader-progressive-disclosure/SKILL.md): Keep the universal skill compact yet discoverable by loading minimal frontmatter first and heavy content on demand.
- [Project-Root Scoped Local Skill Loading](../skills/project-root-scoped-local-skill-loading/SKILL.md): Resolve a stable project root first, then load local skills relative to that scope before combining them with other sources.
- [Memoized Command Source Aggregation](../skills/memoized-command-source-aggregation/SKILL.md): Load independent command sources in parallel, then memoize the merged registry by cwd so repeated lookups stay cheap and ordered.
- [Dynamic Skill Insertion Before Builtins](../skills/dynamic-skill-insertion-before-builtins/SKILL.md): Merge runtime-discovered commands into an existing command registry by deduping them against the enabled base surface and inserting them at a stable boundary before built-in commands.
- [Layered Command Cache Invalidation](../skills/layered-command-cache-invalidation/SKILL.md): Clear every memoized layer in a command or skill pipeline so dynamic updates invalidate outer derived views as well as inner source caches.
- [Descriptive Skill Surface Admission](../skills/descriptive-skill-surface-admission/SKILL.md): Use source-aware admission rules so trusted local skills can surface automatically while plugin or MCP-provided entries must supply explicit descriptive metadata.
- [Slash-Command Skill Classification Filter](../skills/slash-command-skill-classification-filter/SKILL.md): Derive a slash-command skill surface from a broader prompt-command registry by requiring descriptive metadata, excluding builtins, and admitting only a controlled set of origins plus explicit user-only commands.
- [Budget-Aware Skill Listing Formatting](../skills/budget-aware-skill-listing-formatting/SKILL.md): Derive the active model context budget at runtime and format skill listings to fit it instead of emitting raw command sets.
- [Local-and-MCP Skill Name Deduplication](../skills/local-and-mcp-skill-name-deduplication/SKILL.md): Merge local and MCP skill sources into one listing surface and dedupe by stable command name before announcing them.

### Tool Orchestration

Skills for tool batching, streaming, validation, persistence, and output shaping.

- [Concurrency-Safe Tool Batching](../skills/concurrency-safe-tool-batching/SKILL.md): Group tool calls into concurrency-safe batches to run read-only calls in parallel while serializing non-read-only work.
- [Ordered Streaming Tool Execution](../skills/ordered-streaming-tool-execution/SKILL.md): Buffer and execute streaming tool calls with concurrency awareness so results appear in request order even when multiple runners overlap.
- [Progress-First Tool Emission](../skills/progress-first-tool-emission/SKILL.md): Emit progress/value updates as soon as they arrive while still buffering final results and handling cancellations or sibling errors.
- [Circular-Safe Tool Registry Loading](../skills/circular-safe-tool-registry-loading/SKILL.md): Safely assemble the tool registry when optional tools have circular dependencies or heavy side effects.
- [Capability Pool Resolution](../skills/capability-pool-resolution/SKILL.md): Resolve an agent’s tool intent and disallowed lists into the actual pool the agent can use, honoring wildcard, async, and teammate allowances.
- [Required Argument Aware Flag Validation](../skills/required-argument-aware-flag-validation/SKILL.md): Walk command tokens while inspecting attached/inline arguments so validators never skip missing or dangerous flag values.
- [Idempotent Tool Result Persistence](../skills/idempotent-tool-result-persistence/SKILL.md): Persist tool results once, avoid re-writing duplicates, and summarize via previews so long outputs stay accessible yet capped.
- [Modality-Preserving Binary Offload](../skills/modality-preserving-binary-offload/SKILL.md): Persist binary output with a mime-derived extension and a matching saved-file message so downstream tools keep the right modality.
- [Wire-Shape Aligned Budgeting](../skills/wire-shape-aligned-budgeting/SKILL.md): Keep each wire message’s aggregate tool_result size within the configured budget by compacting the largest fresh results first.
- [Tail-Preserving Task Output Truncation](../skills/tail-preserving-task-output-truncation/SKILL.md): Persist tool outputs alongside metadata and truncate only the preview, ensuring the header points back to the persisted replica.
- [Decision Fate Freezing](../skills/decision-fate-freezing/SKILL.md): Freeze each tool result ID's replacement fate after it is observed so budget decisions stay deterministic across turns and forks.

### Context Management

Skills for compaction, memory fetch, retry control, and long-running session stability.

- [Conversation Engine Persistent Session State](../skills/conversation-engine-persistent-session-state/SKILL.md): Keep session-level signals (messages, read caches, memory loads) alive across turns while letting per-turn caches reset for correctness.
- [API Round Message Grouping](../skills/api-round-message-grouping/SKILL.md): Split conversation history into API-round buckets so compaction retries cut only the chunks tied to the failed round.
- [API-Round PTL Retry Truncation](../skills/api-round-ptl-retry-truncation/SKILL.md): On prompt-too-long retries, drop the oldest API-round groups first and inject a synthetic user preamble when needed so the summarize request stays valid.
- [Autocompact Circuit Breaker](../skills/autocompact-circuit-breaker/SKILL.md): Break the autocompact retry loop after several consecutive failures to avoid hammering shared APIs.
- [Autocompact Recursion Guards](../skills/autocompact-recursion-guards/SKILL.md): Block autocompact from running in recursive contexts so forks and helpers don’t deadlock.
- [Reserved Summary Output Budget](../skills/reserved-summary-output-budget/SKILL.md): Reserve part of the context window for summary output so proactive compaction does not kill the response budget.
- [Token Budgeted Compaction With Reinjection](../skills/token-budgeted-compaction-with-reinjection/SKILL.md): Keep compaction budgets under control by compacting incrementally and reinjecting truncated attachments only when the reasoning surface remains stable.
- [Progressive Compaction Prompt](../skills/progressive-compaction-prompt/SKILL.md): Drive compaction summaries through structured prompts that sequence naming, artifacts, and invocation guidance before stripping analysis tags.
- [Compactable Tool Whitelist Gating](../skills/compactable-tool-whitelist-gating/SKILL.md): Only allow cached microcompact to delete tool results for a vetted, pre-gated whitelist of tool names.
- [Time-Gap Cache-Expiry Microcompact](../skills/time-gap-cache-expiry-microcompact/SKILL.md): When a long idle gap means the server cache is cold, clear old tool-result content before the next request instead of attempting warm-cache cache edits.
- [Turn-Scoped Memory Prefetch with Disposal](../skills/turn-scoped-memory-prefetch-with-disposal/SKILL.md): Start a non-blocking, turn-scoped memory prefetch that auto-disposes and only injects results once per turn.

### Multi-Agent

Skills for child agents, forked execution, permission inheritance, and lifecycle cleanup.

- [Additive Agent Tool Surface Construction](../skills/additive-agent-tool-surface-construction/SKILL.md): Merge agent-specific tool sets (MCP clients + fetched tools) into the parent context without disrupting the parent’s existing pool.
- [Agent-Specific MCP Server Initialization](../skills/agent-specific-mcp-server-initialization/SKILL.md): Connect each agent’s frontmatter MCP servers safely and tear them down without leaking clients, while honoring plugin-only guards.
- [Cache Prefix Stability For Subagents](../skills/cache-prefix-stability-for-subagents/SKILL.md): Preserve cache-critical request fields when a child agent must share the parent's prompt prefix for cache hits.
- [Cache Identical Fork Prefix Construction](../skills/cache-identical-fork-prefix-construction/SKILL.md): Build forked conversation prefixes that stay identical across turns so prompt caching keeps working.
- [Permission Overlay Inheritance](../skills/permission-overlay-inheritance/SKILL.md): Layer child permission rules over parent session policy without dropping root-level grants or mutating shared state.
- [Fork Child Directive Guardrails](../skills/fork-child-directive-guardrails/SKILL.md): Keep fork-decoupled workers strictly bounded by directive text and cache sharing requirements.
- [Lifecycle-Scoped Resource Cleanup](../skills/lifecycle-scoped-resource-cleanup/SKILL.md): Release every resource allocated to a child agent inside one unconditional cleanup path so finished or aborted runs leave no lingering hooks, watchers, or background jobs.
- [Forked Skill Execution With Isolated Context](../skills/forked-skill-execution-with-isolated-context/SKILL.md): Run SkillTool slash commands inside a forked sub-agent so the skill has isolated budget, telemetry, and lifecycle.
- [Append-Only Sidechain Transcripts](../skills/append-only-sidechain-transcripts/SKILL.md): Persist subagent transcripts as an append-only ordered log so forks, resumes, and sidechain readers can replay history without duplication.
- [Trusted Frontmatter Gating](../skills/trusted-frontmatter-gating/SKILL.md): Gate frontmatter MCP servers, hooks, and skills behind admin trust when plugin-only or hook-only modes are active.
- [Orphaned Tool Call Sanitizer](../skills/orphaned-tool-call-sanitizer/SKILL.md): Remove assistant messages that reference tools without recorded results before feeding the history back into runAgent.

### Extensions And MCP

Skills for extension reconciliation, headless parity, and runtime activation.

- [Three-Layer Extension Sync](../skills/three-layer-extension-sync/SKILL.md): Model extension lifecycle as intent, materialization, and active runtime layers, then sync each layer with dedicated transitions.
- [Headless Interactive Reconcile Parity](../skills/headless-interactive-reconcile-parity/SKILL.md): Keep interactive and headless extension installation flows behaviorally aligned by sharing reconciliation logic and adapting only the outer contract.

### Safety And Worktrees

Skills for safe shell execution, path guards, worktree reuse, and repo safety.

- [Canonical Worktree Path Normalization](../skills/canonical-worktree-path-normalization/SKILL.md): Resolve repo-relative paths against the canonical checkout root so shared state stays stable across Git worktrees.
- [Fast Worktree Reuse With Head Pointer Checks](../skills/fast-worktree-reuse-with-head-pointer-checks/SKILL.md): Resume existing worktrees quickly by checking stored HEAD pointers before fetching or recreating.
- [Safe Worktree Slug Validation](../skills/safe-worktree-slug-validation/SKILL.md): Ensure Git worktree slugs can never escape the managed workspace or inject traversal.
- [Case-Normalized Sensitive Path Guards](../skills/case-normalized-sensitive-path-guards/SKILL.md): Normalize filesystem paths and reject matches that try to spoof sensitive directories with mixed case or alternate separators.
- [Dangerous Config File Protection](../skills/dangerous-config-file-protection/SKILL.md): Keep writes out of sensitive dotfiles and `.claude` folders by checking canonicalized basenames before granting permission.
- [Declarative Read Only Command Allowlists](../skills/declarative-read-only-command-allowlists/SKILL.md): Express shell-command safety as declarative flag maps so tooling knows exactly what passes.
- [Cross Shell Command Safety Maps](../skills/cross-shell-command-safety-maps/SKILL.md): Describe how to centralize cross-platform safe commands, UNC detection, and per-shell path guards so every shell tool shares the same policy.
- [Remote Safe Command Allowlist](../skills/remote-safe-command-allowlist/SKILL.md): Define a narrow explicit set of commands that stay available in remote mode because they only affect local UI state, then reuse that set at startup and after handshake refinement.
- [Auto Memory Tool Permission Fencing](../skills/auto-memory-tool-permission-fencing/SKILL.md): Gate every tool call in the auto-memory extract agent so only safe read-only actions and targeted writes execute.

### Remote And Bridge

Skills for remote-safe command surfaces, transport contracts, and bridge gating.

- [Bridge Origin Safe Slash Override](../skills/bridge-origin-safe-slash-override/SKILL.md): Keep remote slash-command skipping enabled by default, then reopen it only for bridge-safe commands while denying unsafe local commands with a friendly local response.
- [Type Tiered Bridge Command Gating](../skills/type-tiered-bridge-command-gating/SKILL.md): Gate bridge-executed slash commands by command type first: block local-jsx UI commands, allow prompt commands by construction, and require an explicit allowlist for plain local commands.
- [Bridge Safe Command Advertising](../skills/bridge-safe-command-advertising/SKILL.md): Advertise only slash commands that a bridge client can actually invoke by filtering announcements with the same bridge-safety predicate used at execution time.
- [User-Invocable Capability Serialization](../skills/user-invocable-capability-serialization/SKILL.md): Serialize announced command and skill surfaces from a shared capability shape, excluding entries explicitly marked non-user-invocable.
- [Shared System Init Shape Parity](../skills/shared-system-init-shape-parity/SKILL.md): Centralize `system/init` or capability payload construction in one builder so multiple transports emit identical schemas and only vary inputs or delivery.
- [Privacy-Redacted REPL Bridge System Init](../skills/privacy-redacted-repl-bridge-system-init/SKILL.md): Reuse one `system/init` payload shape across trusted and remote transports, but redact tool, MCP, and plugin metadata when the bridge path would leak local integrations or filesystem paths.
- [Legacy Wire Name Compat Translation](../skills/legacy-wire-name-compat-translation/SKILL.md): Translate renamed internal identifiers back to their legacy wire names at serialization boundaries so patch-level consumers keep working until the planned version cutoff.

### Terminal UI

Skills for terminal presentation, status rows, captions, and motion-aware UI.

- [ANSI-Safe Border Caption Embedding](../skills/ansi-safe-border-caption-embedding/SKILL.md): Embed captions into terminal borders while preserving alignment, clipping, and color/dim semantics.
- [Wrapped Text Style Preservation](../skills/wrapped-text-style-preservation/SKILL.md): Track per-character segments so wrapped or truncated text keeps its original colors and emphasis.
- [Capability Based Spinner Glyph Selection](../skills/capability-based-spinner-glyph-selection/SKILL.md): Select spinner glyphs and colors dynamically based on terminal capability, motion preference, and stall state.
- [Progressive Width Gated Status Rows](../skills/progressive-width-gated-status-rows/SKILL.md): Show status metadata only when the spinner row has room, shrinking entries as viewport width decreases.
- [Reduced-Motion First Terminal Animation](../skills/reduced-motion-first-terminal-animation/SKILL.md): Pause terminal animations when the user requests reduced motion, then resume cleanly without tearing the rest of the UI.
- [Viewport-Aware Animation Pausing](../skills/viewport-aware-animation-pausing/SKILL.md): Stop updating animation ticks as soon as the animated element leaves the viewport so scrollback never forces terminal resets.
- [Scrollback Freeze Optimization](../skills/scrollback-freeze-optimization/SKILL.md): Cache and reuse animated children once they slide into scrollback so terminal resets never occur.
