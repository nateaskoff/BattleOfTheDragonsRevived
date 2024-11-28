import logging
import boto3

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Set up clients
dynamodb = boto3.resource('dynamodb')
ecs = boto3.client('ecs')
s3 = boto3.client('s3')

# Set up environment variables

def lambda_handler(event, context):
    print(event)
    print(context)
    