#!/usr/bin/env bash
# deploy-prompt.sh — render a spirit's CLAUDE.md to the project root
#
# Usage:
#   deploy-prompt.sh [spirit-name]
#
# Without arguments: deploys the guardian's CLAUDE.md
# With a spirit name: deploys from .camps/<name>/CLAUDE.md
#
# Must be run from a project root (directory containing .guardian/).
# The rendered CLAUDE.md at the project root is gitignored — it is
# harness equipment, not a project artefact.
#
# Source of truth:
#   Guardian: .guardian/CLAUDE.md (tracked, committed)
#   Visitor:  .camps/<spirit>/CLAUDE.md (gitignored)

set -euo pipefail

# --- Resolve project root ---
if [[ ! -d .guardian ]]; then
    echo "error: not at a project root (no .guardian/ directory)" >&2
    exit 1
fi

spirit="${1:-}"

if [[ -z "$spirit" ]]; then
    # No argument: deploy guardian
    source=".guardian/CLAUDE.md"
    guardian=$(cat .guardian/identity 2>/dev/null || echo "unknown")
    label="guardian ($guardian)"
else
    # Named spirit: deploy from camp
    source=".camps/$spirit/CLAUDE.md"
    label="visitor ($spirit)"
fi

if [[ ! -f "$source" ]]; then
    echo "error: no CLAUDE.md at $source" >&2
    echo "  Guardian needs: .guardian/CLAUDE.md" >&2
    echo "  Visitor needs:  .camps/<name>/CLAUDE.md (pitch camp first)" >&2
    exit 1
fi

cp "$source" CLAUDE.md
echo "deployed $label → CLAUDE.md"
