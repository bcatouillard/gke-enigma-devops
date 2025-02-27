resource "google_project_iam_binding" "gke_access" {
  project = var.project
  role    = "roles/container.developer"

  members = var.students
}


resource "google_project_iam_binding" "gcr_build_push" {
  project = var.project
  role    = "roles/storage.objectAdmin"

  members = var.students
}

resource "google_project_iam_binding" "gke_pull_gcr" {
  project = var.project
  role    = "roles/storage.objectViewer"

  members = ["serviceAccount:${data.google_service_account.gke_sa.email}"]
}
