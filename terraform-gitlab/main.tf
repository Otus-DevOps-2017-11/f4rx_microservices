provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}


resource "google_compute_instance" "gitlab" {
  name         = "gitlab"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["default-allow-ssh", "docker-host"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
      size = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    sshKeys = "${var.admin_user}:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "${var.admin_user}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop sshguard",
      "sudo systemctl disable sshguard",
    ]
  }

}

resource "google_compute_firewall" "docker-host-allow-all" {
  name    = "docker-host-allow-all"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp",
    ports = ["0-65535"],
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-host"]
}
