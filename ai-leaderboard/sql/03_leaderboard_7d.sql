-- sql/03_leaderboard_7d.sql  (optional scheduled query)
DECLARE run_date DATE DEFAULT @run_date;
DELETE FROM ai_dash.leaderboard_7d WHERE snapshot = run_date;

INSERT INTO ai_dash.leaderboard_7d
SELECT
  bot,
  COUNT(DISTINCT repo) AS repo_count,
  run_date             AS snapshot
FROM ai_dash.repo_bot_snapshot
WHERE snapshot BETWEEN DATE_SUB(run_date, INTERVAL 6 DAY) AND run_date
GROUP BY bot;