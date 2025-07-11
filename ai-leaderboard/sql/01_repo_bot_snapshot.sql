-- sql/01_repo_bot_snapshot.sql
DECLARE run_date DATE DEFAULT @run_date;        -- supplied by scheduler
DELETE FROM ai_dash.repo_bot_snapshot WHERE snapshot = run_date;

INSERT INTO ai_dash.repo_bot_snapshot
SELECT DISTINCT repo, bot, run_date
FROM `your_project.githubarchive.day.*`
WHERE _TABLE_SUFFIX = FORMAT_DATE('%Y%m%d', run_date)
  AND type = 'PullRequestReviewEvent'
  AND bot IN ('ellipsisai','coderabbitai','greptile[bot]' /* … */);