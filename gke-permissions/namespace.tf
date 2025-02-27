resource "kubernetes_namespace" "students_namespaces" {
  for_each = toset(var.students)
  metadata {
    name = "${each.key}-ns"
  }
}
