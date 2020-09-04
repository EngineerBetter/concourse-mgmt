#!/usr/bin/env bash

set -euo pipefail

fly --target target login \
  --concourse-url "${CONCOURSE_URL}" \
  --username "${CONCOURSE_USERNAME}" \
  --password "${CONCOURSE_PASSWORD}" \
  --insecure

config_files="$(fd .*\.yml "configs/${ENV}" --max-depth 1)"

while read -r team_file; do
  team_name=$(basename "${team_file}" | sed 's/.yml//')
  echo "$team_name is being set with config: $team_file"
  fly --target target \
    set-team \
    --team-name="${team_name}" \
    --config="${team_file}" \
    --non-interactive
done <<< "${config_files}"
