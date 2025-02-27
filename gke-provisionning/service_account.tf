resource "google_service_account" "gke_sa" {
  account_id   = "${var.project}-gke-sa"
  display_name = "Enigma GKE Service Account"
}

resource "google_service_account" "github_sa" {
  account_id   = "${var.project}-github-actions-sa"
  display_name = "Enigma Github Actions Service Account"
}

resource "google_project_iam_binding" "github_sa_iam" {
  project = var.project
  role    = "roles/storage.admin"

  members = ["serviceAccount:${google_service_account.github_sa.email}"]
}

resource "google_service_account_key" "github_actions_key" {
  service_account_id = google_service_account.github_sa.name
}

resource "local_file" "github_actions_key" {
  filename = "${path.module}/github-actions-key.json"
  content  = base64decode(google_service_account_key.github_actions_key.private_key)
}