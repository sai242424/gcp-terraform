provider "google" {
  region = "us-central1"
}

resource "google_pubsub_topic" "example" {
  name = var.topic

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
