provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source             = "../modules/app"
  public_key_path    = "${var.public_key_path}"
  zone               = "${var.zone}"
  app_disk_image     = "${var.app_disk_image}"
  access_to_app_from = ["0.0.0.0/0"]
  need_deploy        = "false"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vcp" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}
