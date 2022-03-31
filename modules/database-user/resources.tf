resource "kubernetes_job" "database_setup" {
  metadata {
    name = "database-setup-${var.user}"
  }

  spec {
    ttl_seconds_after_finished = 3600
    template {
      metadata {}
      spec {
        container {
          name    = "mysql"
          image   = var.mysql_image
          command = ["bash", "-c", "/script/script.sh"]

          env_from {
            config_map_ref {
              name = "mysql-config"
            }
          }

          env_from {
            secret_ref {
              name = "mysql-root-credentials"
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.database_credentials.metadata.0.name
            }
          }

          volume_mount {
            name       = "database-setup-script"
            mount_path = "/script"
          }
        }

        volume {
          name = "database-setup-script"

          config_map {
            name         = kubernetes_config_map.database_setup_script.metadata.0.name
            default_mode = "0755"
          }
        }

        restart_policy = "Never"
      }
    }

    backoff_limit = 5
  }

  wait_for_completion = true
}

resource "kubernetes_secret" "database_credentials" {
  metadata {
    name = "database-credentials-${var.user}" 
  }

  data = {
    USER = var.user
    PASSWORD = var.password
  }
}

resource "kubernetes_config_map" "database_setup_script" {
  metadata {
    name = "database-setup-script-${var.user}"
  }

  data = {
    "script.sh" = file("${path.module}/files/script.sh")
  }
}

