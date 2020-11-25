output "service_name" {
  value = kubernetes_service.wordpress.metadata.0.name
}
