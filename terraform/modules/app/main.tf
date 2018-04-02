resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "null_resource" "app" {
  count = "${var.need_deploy ? 1 : 0}"

  connection {
    host        = "${element(google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_service_tpl.rendered}"
    destination = "/tmp/puma.service"
  }

#  provisioner "file" {
#    source      = "${path.module}/files/puma.service"
#    destination = "/tmp/puma.service"
#  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "${var.app_proto}"
    ports    = "${var.app_port}"
  }

  source_ranges = "${var.access_to_app_from}"
  target_tags   = ["reddit-app"]
}

data "template_file" "puma_service_tpl" {
  template = "${file("${path.module}/files/puma.service.tpl")}"

  vars {
    mongo_ip = "${var.mongo_ip}"
  }
}
