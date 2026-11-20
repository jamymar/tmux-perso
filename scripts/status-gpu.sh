#!/usr/bin/env bash
# Ne rien afficher en absence de GPU NVIDIA visible.
command -v nvidia-smi >/dev/null 2>&1 || exit 0
value="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '/^[[:space:]]*[0-9]+[[:space:]]*$/ { sum += $1; n++ } END { if (n) printf "%.0f", sum/n }')"
[[ -n "$value" ]] || exit 0
printf '#[fg=#c6a0f6,bg=#363a4f] GPU %s%% #[default]' "$value"
