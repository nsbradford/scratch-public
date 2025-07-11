-- sql/00_schema.sql  (run once)
CREATE TABLE IF NOT EXISTS ai_dash.repo_bot_snapshot (
  repo      STRING,
  bot       STRING,
  snapshot  DATE
) PARTITION BY snapshot;

CREATE TABLE IF NOT EXISTS ai_dash.leaderboard_daily (
  snapshot   DATE,
  bot        STRING,
  repo_count INT64
) PARTITION BY snapshot;