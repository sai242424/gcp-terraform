provider "google" {
  project = "dataplatformfoundation-01"
  region = "us-central1"
}


resource "google_pubsub_topic" "stream1" {
  name = "dataplatformfoundation_stream_json"

  message_retention_duration = "86600s"
}


resource "google_bigquery_table" "default" {
  dataset_id = "dataplatformfoundation_streaming"
  table_id   = "dataplatform_usa_names_stream_json_terraform"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "subverticals",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "subverticals"
  },
  {
    "name": "job_location",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "job_location"
  },
  {
    "name": "job_description_id",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "job_description_id"
  },
  {
    "name": "job_description",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "job_description"
  },
  {
    "name": "jd_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "jd_id"
  },
  {
    "name": "job_title",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "job_title"
  },
  {
    "name": "ecosystem_company_id",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "ecosystem_company_id"
  },
  {
    "name": "job_posting_date",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "job_posting_date"
  },
  {
    "name": "core_skills",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "core_skills"
  },
  {
    "name": "digital_products",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "digital_products"
  },
  {
    "name": "company_name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "company_name"
  },
  {
    "name": "created_on",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "created_on"
  },
  {
    "name": "updated_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "updated_at"
  },
  {
    "name": "account_id",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "account_id"
  }
]
EOF

}
