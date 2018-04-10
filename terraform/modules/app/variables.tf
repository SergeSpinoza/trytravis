variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable app_port {
  description = "Application port"
  default     = ["9292"]
}

variable app_proto {
  description = "Application protocol"
  default     = "tcp"
}

variable access_to_app_from {
  description = "Source ip access to application"
  default     = ["8.8.8.8/32"]
}

variable need_deploy {
  description = "Deploy application"
}

variable mongo_ip {
  description = "Mongo DB IP"
}

variable nginx_port {
  description = "Nginx port"
  default     = ["80"]
}

variable access_to_nginx_from {
  description = "Source ip access to nginx"
  default     = ["0.0.0.0/0"]
}
