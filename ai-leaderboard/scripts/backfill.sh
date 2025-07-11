#!/usr/bin/env bash
set -euo pipefail
PROJECT="$(gcloud config get-value project)"
CFG="$(gcloud bq transfers list --project="$PROJECT" \
  --filter='displayName=Repo-Bot Snapshot Daily' \
  --format='value(name)')"

# scripts/backfill.sh  (test run: last 30 days only)
START="$(date -u -d '30 days ago' +%Y-%m-%d)T05:00:00Z"
END="$(date -u -d 'yesterday'    +%Y-%m-%d)T05:00:00Z"

gcloud bq transfers start-manual-runs "$CFG" \
  --project="$PROJECT"           \
  --start-time="$START"          \
  --end-time="$END"