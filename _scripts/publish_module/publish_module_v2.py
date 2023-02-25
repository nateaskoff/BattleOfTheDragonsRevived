import os
import boto3
import botocore

env = input("Enter the environment to deploy the latest module to [dev/prod]:")

awsSession = boto3.Session()
awsS3Client = boto3.client('s3')
awsS3resource = boto3.resource('s3')
awsCredentials = awsSession.get_credentials()
awsCredentials = awsCredentials.get_frozen_credentials()
aws_access_key_id = awsCredentials.access_key
aws_secret_access_key = awsCredentials.secret_key

# global string vars
moduleName = "Battle Of The Dragons Revived"

# local string vars
localModuleFileName = f"{moduleName}.mod"
devs3ModuleKey = f"s3://dev-botdr-s3-webcode-bucket/{moduleName}.mod"
prods3ModuleKey = f"s3://prod-botdr-s3-webcode-bucket/{moduleName}.mod"

if env == "dev":
