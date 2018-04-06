terraform {
  backend "gcs" {
    bucket = "spinoza-storage-bucket-1"
    prefix = "terraform/state"
  }
}
