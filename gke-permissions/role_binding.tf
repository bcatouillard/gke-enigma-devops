resource "kubernetes_role_binding" "student_role_binding" {
  for_each = toset(var.students)
  metadata {
    name      = "students-role-binding"
    namespace = "${each.value}-ns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_cluster_role.students_role.metadata.name
  }
  subject {
    kind      = "User"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [kubernetes_namespace.students_namespaces]
}
