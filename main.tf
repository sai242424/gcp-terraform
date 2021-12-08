provider "google" {
  project = "dataplatformfoundation-01"
  region = "us-central1"
}

/*
resource "google_pubsub_topic" "example1" {
  name = "dataplatformfoundation_test_1"

  message_retention_duration = "86600s"
}
*/

resource "google_bigquery_table" "default" {
  dataset_id = "dataplatformfoundation-01:dataplatformfoundation_streaming"
  table_id   = "dataplatform_usa_names_terraform"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State"
  },
  {
    "name": "gender",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Gender"
  },
  {
    "name": "year",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "Year"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Name"
  },
  {
    "name": "number",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "Number"
  },
  {
    "name": "created_date",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Created_date"
  }  
]
EOF

}
