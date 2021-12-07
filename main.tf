provider "google" {
  region = "us-central1"
}

resource "google_pubsub_topic" "example" {
  name = "dataplatformfoundation_test"

  message_retention_duration = "86600s"
}
