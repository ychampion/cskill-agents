---
name: modality-preserving-binary-offload
description: "Persist binary output with a mime-derived extension and a matching saved-file message so downstream tools keep the right modality."
metadata:
  author: ychampion
---

# SKILL: Modality-Preserving Binary Offload
**Domain:** tool-result-storage
**Trigger:** Apply when a tool emits binary content that must be saved out of band without losing the file type or downstream usability.
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Preserve modality by deriving the output extension from MIME type, writing the raw bytes unchanged, and returning a saved-file message that names the type, size, and location. This ensures the resulting file can be opened by the correct downstream tool chain instead of being flattened into an opaque blob with the wrong extension. The offload path remains generic while still honoring modality-specific dispatch.

## Key Rules
- Strip MIME parameters before extension lookup so content types like application pdf; charset binary still resolve correctly.
- Use conservative extension mapping: known types get their proper extension and unknown types fall back to `bin`.
- Write bytes as-is rather than stringifying them, or the saved artifact will no longer be usable by native readers.
- Return a human-readable saved-file message with MIME, size, and path so downstream agents know what was persisted.

## Example Application
If an MCP server returns a PDF or spreadsheet, derive `pdf` or `xlsx` from the MIME type, persist the raw bytes into the tool-results directory, and emit a saved-file message so later steps can hand the file to a PDF reader or spreadsheet parser without guessing the format.

## Anti-Patterns (What NOT to do)
- Do not save binary content with a generic text extension; downstream tooling dispatch often depends on the suffix.
- Do not stringify binary bytes before writing; that destroys the original modality and makes the file unusable.
