terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}

variable "project" {
  description = "Google Cloud project ID that owns the BigQuery dataset"
  type        = string
}

provider "google" {
  project = var.project
  region  = "us-central1"
}

# Dataset
resource "google_bigquery_dataset" "ai_dash" {
  dataset_id = "ai_dash"
  location   = "US"
}

# ------------------ daily snapshot job ------------------
resource "google_bigquery_data_transfer_config" "snapshot" {
  display_name           = "Repo-Bot Snapshot Daily"
  data_source_id         = "scheduled_query"
  destination_dataset_id = google_bigquery_dataset.ai_dash.dataset_id
  schedule               = "every day 05:00"
  params = {
    query             = file("${path.module}/../../sql/01_repo_bot_snapshot.sql")
    write_disposition = "WRITE_TRUNCATE"
  }
}

# ------------------ daily roll-up job ------------------
resource "google_bigquery_data_transfer_config" "leaderboard_daily" {
  display_name           = "Leaderboard Daily"
  data_source_id         = "scheduled_query"
  destination_dataset_id = google_bigquery_dataset.ai_dash.dataset_id
  schedule               = "every day 05:05"
  params = {
    query             = file("${path.module}/../../sql/02_leaderboard_daily.sql")
    write_disposition = "WRITE_TRUNCATE"
  }
}

# ------------------ 7-day roll-up job (optional) -------
resource "google_bigquery_data_transfer_config" "leaderboard_7d" {
  display_name           = "Leaderboard 7-Day"
  data_source_id         = "scheduled_query"
  destination_dataset_id = google_bigquery_dataset.ai_dash.dataset_id
  schedule               = "every day 05:10"
  params = {
    query             = file("${path.module}/../../sql/03_leaderboard_7d.sql")
    write_disposition = "WRITE_TRUNCATE"
  }
}