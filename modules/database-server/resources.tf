resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    service_name = "mysql"

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = var.mysql_image

          env_from {
            secret_ref {
              name = kubernetes_secret.mysql_root_credentials.metadata.0.name
            }
          }

          volume_mount {
            name       = "mysql"
            mount_path = "/var/lib/mysql"
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

    volume_claim_template {
      metadata {
        name = "mysql"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = var.storage
          }
        }
      }
    }
  }

  wait_for_rollout = true
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    selector = {
      app = kubernetes_stateful_set.mysql.metadata.0.name
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_config_map" "mysql_config" {
  metadata {
    name = "mysql-config"
  }

  data = {
    MYSQL_HOST = kubernetes_service.mysql.metadata.0.name
  }
}

resource "kubernetes_secret" "mysql_root_credentials" {
  metadata {
    name = "mysql-root-credentials"
  }

  data = {
    MYSQL_ROOT_PASSWORD = var.root_password
  }
}