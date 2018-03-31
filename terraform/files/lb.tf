resource "google_compute_instance_group" "app-group" {
  name      = "tf-reddit-app-group"
  zone      = "${var.zone}"
  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "puma-port"
    port = "9292"
  }
}

resource "google_compute_http_health_check" "app-health-check" {
  name               = "tf-app-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = "9292"
}

resource "google_compute_backend_service" "app-backend-service" {
  name        = "tf-app-backend-service"
  port_name   = "puma-port"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.app-group.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.app-health-check.self_link}"]
}

resource "google_compute_url_map" "app-map" {
  name            = "tf-app-map"
  default_service = "${google_compute_backend_service.app-backend-service.self_link}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "tf-allpaths"
  }

  path_matcher {
    name            = "tf-allpaths"
    default_service = "${google_compute_backend_service.app-backend-service.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.app-backend-service.self_link}"
    }
  }
}

resource "google_compute_target_http_proxy" "http-lb-proxy" {
  name    = "tf-http-lb-proxy"
  url_map = "${google_compute_url_map.app-map.self_link}"
}

resource "google_compute_global_forwarding_rule" "forward-http-content" {
  name       = "tf-forward-http-content"
  target     = "${google_compute_target_http_proxy.http-lb-proxy.self_link}"
  port_range = "80"
}

# example https://github.com/terraform-providers/terraform-provider-google/blob/master/examples/content-based-load-balancing/main.tf

