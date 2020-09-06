resource "docker_container" "httpd" {
  name  = var.name
  image = "httpd:${var.httpd_version}"

  ports {
    internal = 80
    external = var.port
  }

  volumes {
    host_path = dirname(local_file.index.filename)
    container_path = "/usr/local/apache2/htdocs"
  }
}

resource "local_file" "index" {
  filename = "/tmp/sonatina-${var.name}/index.html"
  content = templatefile("${path.module}/templates/index.html", 
                         { sentence = var.sentence })
}