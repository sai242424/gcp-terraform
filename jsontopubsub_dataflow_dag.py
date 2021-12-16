
"""Example Airflow DAG that creates a Cloud Dataflow streaming workflow which takes
json file from bucket and publish it to pubsub

This DAG relies on four Airflow variables
https://airflow.apache.org/docs/apache-airflow/stable/concepts/variables.html
* project_id - Google Cloud Project ID to use for the Cloud Dataflow cluster.
* gce_zone - Google Compute Engine zone where Cloud Dataflow cluster should be
  created.
For more info on zones where Dataflow is available see:
https://cloud.google.com/dataflow/docs/resources/locations
* bucket_path - Google Cloud Storage bucket where you've stored the User Defined
Function (.js), the input file (.txt), and the JSON schema (.json).
"""


import sys
import os
import datetime
import airflow
from airflow.operators.dummy_operator import DummyOperator
from airflow import models
from airflow.providers.google.cloud.operators.dataflow import DataflowTemplatedJobStartOperator
from airflow.utils.dates import days_ago



dag_name="gcstopubsub_dataflow_composer"
project_id="dataplatformfoundation-01"
dml_directory="dataplatformfoundation-01/data_files"

default_args = {
		'depends_on_past' : False,
		'retries' : 1,
		'retry_delay' : datetime.timedelta(minutes=5)
		}
 
with airflow.DAG(
		dag_id=dag_name,
		default_args=default_args,
		start_date=airflow.utils.dates.days_ago(0),
		max_active_runs=1,
        #Add scheduler time interval
        #Schedule set for every day 4th hr and 5th minute 
        #schedule_interval="5 4 * * *",
		template_searchpath=[dml_directory]) as dag:
        
        start_task = DummyOperator(task_id = "start" , dag=dag)
        
        start_template_job_gcstopubsub = DataflowTemplatedJobStartOperator(
        # The task id of your job
        task_id="dataflow_operator_json_to_pubbsub",
        # The name of the template that you're using.
        # Below is a list of all the templates you can use.
        # For versions in non-production environments, use the subfolder 'latest'
        # https://cloud.google.com/dataflow/docs/guides/templates/provided-batch#gcstexttobigquery
        template="gs://dataflow-templates/latest/Stream_GCS_Text_to_Cloud_PubSub",
        # Use the link above to specify the correct parameters for your template.
        parameters={
            "outputTopic": "projects/dataplatformfoundation-01/topics/dataplatformfoundation_stream_json",
            "inputFilePattern": "gs://dataplatformfoundation-01/data_files/Job_Descriptions*.json",
           # "gcpTempLocation" : "gs://dataplatformfoundation-01/temp11"
        },
        
        )
        
        #gs://dataflow-templates/latest/PubSub_to_BigQuery
        
        start_template_job_pubsubtobq = DataflowTemplatedJobStartOperator(
        # The task id of your job
        task_id="dataflow_operator_pubbsub_to_bigquery",
        # The name of the template that you're using.
        # Below is a list of all the templates you can use.
        # For versions in non-production environments, use the subfolder 'latest'
        # https://cloud.google.com/dataflow/docs/guides/templates/provided-batch#gcstexttobigquery
        template="gs://dataflow-templates/latest/PubSub_to_BigQuery",
        # Use the link above to specify the correct parameters for your template.
        parameters={
            "inputTopic": "projects/dataplatformfoundation-01/topics/dataplatformfoundation_stream_json",
            "outputTableSpec": "dataplatformfoundation-01:dataplatformfoundation_streaming.dataplatform_usa_names_stream_json_terraform",
        },
        
        )
        
        
        end_task = DummyOperator(task_id = "end" , dag=dag)
        
        start_task >> start_template_job_gcstopubsub >> start_template_job_pubsubtobq >> end_task