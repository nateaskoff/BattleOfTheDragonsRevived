import os
import logging
import boto3
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# Configuration
APP_ENV = os.getenv("APP_ENV", "dev")
AWS_REGION = os.getenv("AWS_REGION")
S3_BUCKET = os.getenv("AWS_S3_MOD_BUCKET_ID")
MODULE_NAME = "Battle_Of_The_Dragons_Revived.mod"
DEFAULT_MOD_LOCATION = os.path.expanduser("~/modules")

# S3 client setup
logger.info("Setting up AWS clients...")
s3_client = boto3.client("s3", region_name=AWS_REGION)
logger.info("Begin NWN server startup process...")

def download_mod_from_s3(S3Bucket: str, S3Key: str, DestinationDir: str) -> None:
    """
    Downloads a module file from an S3 bucket and sets appropriate permissions.

    :param S3Bucket: Name of the S3 bucket
    :param S3Key: Key of the file in the S3 bucket
    :param DestinationDir: Directory where the file will be saved
    """
    try:
        logger.info("Downloading mod from S3 bucket...")
        destination_path = os.path.join(DestinationDir, S3Key)
        s3_client.download_file(S3Bucket, S3Key, destination_path)

        logger.info("Mod downloaded successfully")

        logger.info("Setting mod file permissions...")
        os.chmod(destination_path, 0o775)
        logger.info("Mod file permissions set successfully")
    except ClientError as e:
        logger.error("Error downloading mod from S3: %s", e)
        raise e

if __name__ == "__main__":
    # Download the module from S3
    download_mod_from_s3(S3_BUCKET, MODULE_NAME, DEFAULT_MOD_LOCATION)
