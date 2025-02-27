resource "kubernetes_cluster_role" "students_role" {
  metadata {
    name = "students-role"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["services", "configmaps", "secrets"]
    verbs      = ["create", "get", "list", "watch", "update", "delete"]
  }
}
