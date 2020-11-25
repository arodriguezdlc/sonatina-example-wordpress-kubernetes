resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress-${var.user_component}"
    labels = {
      app            = "wordpress"
      user_component = var.user_component
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app            = "wordpress"
        user_component = var.user_component
      }
    }

    template {
      metadata {
        labels = {
          app            = "wordpress"
          user_component = var.user_component
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = var.image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.wordpress_database.metadata.0.name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.wordpress_database.metadata.0.name
            }
          }

          resources {
            limits {
              cpu    = var.cpu_limit
              memory = var.ram_limit
            }
            requests {
              cpu    = var.cpu_request
              memory = var.ram_request
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "wordpress_database" {
  metadata {
    name = "wordpress-database-${var.user_component}"
  }

  data = {
    WORDPRESS_DB_HOST = "mysql"
    WORDPRESS_DB_USER = var.database_user
    WORDPRESS_DB_NAME = var.database_user
  }
}

resource "kubernetes_secret" "wordpress_database" {
  metadata {
    name = "wordpress-database-${var.user_component}"
  }

  data = {
    WORDPRESS_DB_PASSWORD = var.database_password
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress-${var.user_component}"
  }

  spec {
    selector = kubernetes_deployment.wordpress.metadata.0.labels

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}
