provider "google" {
  project = "dataplatformfoundation-01"
  region = "us-central1"
}

resource "google_pubsub_topic" "example1" {
  name = "dataplatformfoundation_test_1"

  message_retention_duration = "86600s"
}
