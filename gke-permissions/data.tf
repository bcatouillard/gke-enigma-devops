data "google_compute_zones" "available_zones" {
  region = var.region
}

data "google_service_account" "gke_sa" {
  account_id = "${var.project}-gke-sa"
}

data "google_service_account_access_token" "gke_sa_token" {
  target_service_account = data.google_service_account.gke_sa.email
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3600s"
}


data "google_container_cluster" "my_cluster" {
  name     = "${var.project}-gke"
  location = data.google_compute_zones.available_zones.names[0]
}

