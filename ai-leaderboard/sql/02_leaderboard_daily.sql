-- sql/02_leaderboard_daily.sql
DECLARE run_date DATE DEFAULT @run_date;
DELETE FROM ai_dash.leaderboard_daily WHERE snapshot = run_date;

INSERT INTO ai_dash.leaderboard_daily
SELECT
  bot,
  COUNT(DISTINCT repo) AS repo_count,
  run_date             AS snapshot
FROM ai_dash.repo_bot_snapshot
WHERE snapshot = run_date
GROUP BY bot;