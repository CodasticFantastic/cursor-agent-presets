#!/bin/bash
# KISS simplicity hook
# Runs after every file edit by the agent.
# - Detects source files
# - Reminds about KISS when complexity/ceremony smells are likely
# - Optionally runs ESLint complexity heuristics when available
# - Logs results for the developer
# - Never blocks the agent (fail-open)

set -euo pipefail

# Read JSON payload from stdin
input=$(cat)

# Extract file path (requires jq; fallback if missing)
if command -v jq >/dev/null 2>&1; then
  file_path=$(echo "$input" | jq -r '.file_path // empty')
else
  # Minimal fallback – best-effort extraction
  file_path=$(echo "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4 || true)
fi

# Exit early if no file path
[[ -z "${file_path:-}" ]] && { echo '{"continue": true}'; exit 0; }

# Only process application source files
case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.py|*.java|*.kt|*.cs|*.go)
    ;;
  *)
    echo '{"continue": true}'
    exit 0
    ;;
esac

log_dir=".cursor/logs/hooks"
mkdir -p "$log_dir"
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
log_file="$log_dir/kiss-$(date +%Y%m%d).log"

echo "[$timestamp] Edited source file: $file_path" >> "$log_file"
echo "[$timestamp] KISS reminder: prefer clarity over cleverness, YAGNI (no speculative options), delay abstractions until a second use case, keep surfaces small, justify new deps, use shallow flow / early returns. For package audits use audit-coverage.md — do not stop at one clever helper. Invoke /kiss or /kiss-reviewer." >> "$log_file"

# Try to run eslint complexity / max-depth / max-params heuristics when available
if command -v npx >/dev/null 2>&1 && [[ -f package.json ]]; then
  if [[ -d node_modules/eslint ]] || grep -q '"eslint"' package.json 2>/dev/null; then
    echo "[$timestamp] Running eslint complexity checks on $file_path" >> "$log_file"

    if eslint_output=$(npx eslint "$file_path" \
      --rule 'complexity: [warn, 10]' \
      --rule 'max-depth: [warn, 3]' \
      --rule 'max-params: [warn, 4]' \
      --rule 'max-lines-per-function: [warn, { max: 80, skipBlankLines: true, skipComments: true }]' \
      --format unix 2>&1); then
      echo "[$timestamp] eslint: no complexity warnings" >> "$log_file"
    else
      echo "[$timestamp] eslint findings (complexity heuristics — not a KISS verdict):" >> "$log_file"
      echo "$eslint_output" >> "$log_file"
    fi
  else
    echo "[$timestamp] eslint not installed – skipping complexity lint" >> "$log_file"
  fi
else
  echo "[$timestamp] No package.json or npx – skipping complexity lint" >> "$log_file"
fi

# Always continue – do not block the agent
echo '{"continue": true}'
exit 0
