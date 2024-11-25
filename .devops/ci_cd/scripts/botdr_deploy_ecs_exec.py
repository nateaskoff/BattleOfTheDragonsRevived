import os
import time
import boto3

# Get environment variables
AWS_ENV = os.getenv('TF_VAR_env')
AWS_REGION = os.getenv('AWS_REGION')
AWS_ECS_CLUSTER = os.getenv('AWS_ECS_CLUSTER')
AWS_ECS_SERVICE = os.getenv('AWS_ECS_SERVICE')

# Set up boto3 client
print('Setting up boto3 clients...')
ecs = boto3.client('ecs', region_name=AWS_REGION)

# List tasks in the service
print('Listing tasks in the ECS service...')
tasks = ecs.list_tasks(
    cluster=AWS_ECS_CLUSTER,
    serviceName=AWS_ECS_SERVICE
)['taskArns']

# If no tasks are found, gracefully exit the script
if not tasks:
    print('No tasks found for the ECS service.')
    exit(0)  # Exit without doing anything else

# Get the first task ID (or refine logic to select a specific task)
task_id = tasks[0].split('/')[-1]

# Run ECS exec against the task ID
print(f'Running ecs exec against task ID {task_id}...')
response = ecs.execute_command(
    cluster=AWS_ECS_CLUSTER,
    task=task_id,
    command=f"bash /home/nwserver-user/botdr_deploy_notification.sh",
    container=f"{AWS_ENV}-botdr-ecs-container",
    interactive=True
)

print(f'ECS exec response: {response}')

print('Waiting 30 seconds...')
time.sleep(30)

print('Command executed successfully.')
