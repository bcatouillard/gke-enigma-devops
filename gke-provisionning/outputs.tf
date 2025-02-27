output "cluster_endpoint" {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = google_container_cluster.primary.endpoint
}

output "client_certificate" {
  description = "Public certificate used by clients to authenticate to the cluster endpoint."
  value       = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
}

output "client_key" {
  description = "Private key used by clients to authenticate to the cluster endpoint."
  sensitive   = true
  value       = base64decode(google_container_cluster.primary.master_auth[0].client_key)
}


output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  sensitive   = true
  value       = base64decode((google_container_cluster.primary.master_auth[0].cluster_ca_certificate))
}


