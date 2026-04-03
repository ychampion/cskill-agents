# Public Provenance Model

This repository intentionally uses coarse public provenance.

## Public Fields

Public catalogs and per-skill metadata may include:
- category
- pattern family
- review status
- bundle membership
- compatibility targets

## Private Evidence

Maintainers may keep richer private evidence outside this repository for audit or authoring purposes, but those materials are not part of the public distribution.

## Public Redaction Rules

Public files must not include:
- absolute local paths
- raw internal repository paths
- source_repo fields
- source_paths fields
- mirrored file/line references from protected repositories

## Goal

The goal is to publish reusable engineering methods, not a structured derivative of any upstream codebase.
