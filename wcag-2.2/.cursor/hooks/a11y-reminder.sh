#!/bin/bash
# WCAG 2.2 accessibility hook
# Runs after every file edit by the agent.
# - Detects UI files
# - Runs eslint-plugin-jsx-a11y when available
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

# Only process UI-related files
case "$file_path" in
  *.tsx|*.jsx|*.vue|*.svelte|*.html|*.css|*.scss)
    ;;
  *)
    echo '{"continue": true}'
    exit 0
    ;;
esac

log_dir=".cursor/logs/hooks"
mkdir -p "$log_dir"
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
log_file="$log_dir/a11y-$(date +%Y%m%d).log"

echo "[$timestamp] Edited UI file: $file_path" >> "$log_file"

# Try to run eslint with jsx-a11y if the project has it
if command -v npx >/dev/null 2>&1 && [[ -f package.json ]]; then
  if grep -q '"eslint-plugin-jsx-a11y"' package.json 2>/dev/null || \
     grep -q '"eslint-plugin-jsx-a11y"' package-lock.json 2>/dev/null || \
     [[ -d node_modules/eslint-plugin-jsx-a11y ]]; then

    echo "[$timestamp] Running eslint-plugin-jsx-a11y on $file_path" >> "$log_file"

    # Run eslint (non-blocking, capture output)
    if eslint_output=$(npx eslint "$file_path" --plugin jsx-a11y --format unix 2>&1); then
      echo "[$timestamp] eslint: no issues" >> "$log_file"
    else
      echo "[$timestamp] eslint findings:" >> "$log_file"
      echo "$eslint_output" >> "$log_file"
    fi
  else
    echo "[$timestamp] eslint-plugin-jsx-a11y not installed – skipping lint" >> "$log_file"
  fi
else
  echo "[$timestamp] No package.json or npx – skipping lint" >> "$log_file"
fi

# Always continue – do not block the agent
echo '{"continue": true}'
exit 0
