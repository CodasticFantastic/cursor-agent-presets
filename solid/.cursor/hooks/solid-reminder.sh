#!/bin/bash
# SOLID design hook
# Runs after every file edit by the agent.
# - Detects source files
# - Reminds about SOLID when complexity/coupling smells are likely
# - Optionally runs ESLint complexity rules when available
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
log_file="$log_dir/solid-$(date +%Y%m%d).log"

echo "[$timestamp] Edited source file: $file_path" >> "$log_file"
echo "[$timestamp] SOLID reminder: prefer SRP splits (incl. utils/validators), closed cores + strategies (list scattered switches), substitutable subtypes (check page/route call sites), narrow ports, injected abstractions (no concrete cycles / new Gateway in UI). For package audits use audit-coverage.md — do not stop at one god class. Invoke /solid or /solid-reviewer." >> "$log_file"

# Try to run eslint complexity / max-lines heuristics when available
if command -v npx >/dev/null 2>&1 && [[ -f package.json ]]; then
  if [[ -d node_modules/eslint ]] || grep -q '"eslint"' package.json 2>/dev/null; then
    echo "[$timestamp] Running eslint complexity checks on $file_path" >> "$log_file"

    if eslint_output=$(npx eslint "$file_path" --rule 'complexity: [warn, 10]' --rule 'max-lines-per-function: [warn, { max: 80, skipBlankLines: true, skipComments: true }]' --format unix 2>&1); then
      echo "[$timestamp] eslint: no complexity warnings" >> "$log_file"
    else
      echo "[$timestamp] eslint findings (complexity heuristics — not a SOLID verdict):" >> "$log_file"
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
