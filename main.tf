provider "google" {
  region = "us-central1"
}

resource "google_pubsub_topic" "example" {
  name = var.topic
  project_id ="dataplatformfoundation-01"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
