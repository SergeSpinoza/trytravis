provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["spinoza-storage-bucket-1", "spinoza-storage-bucket-2"]
}

# module "vcp" {
#  source        = "modules/vpc"
#  source_ranges = ["0.0.0.0/0"]
# }

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
