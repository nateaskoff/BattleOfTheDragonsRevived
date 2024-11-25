import subprocess
import os
import logging
import boto3
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# Configuration
APP_ENV = os.getenv("APP_ENV", "dev")
S3_BUCKET = os.getenv("AWS_S3_MOD_BUCKET_ID")
BOTDR_ADMIN_PASSWORD_SECRET_ARN = os.getenv("BOTDR_ADMIN_PASSWORD_SECRET_ARN")
BOTDR_DM_PASSWORD_SECRET_ARN = os.getenv("BOTDR_DM_PASSWORD_SECRET_ARN")
if APP_ENV == "dev":
    BOTDR_PLAYER_PASSWORD_SECRET_ARN = os.getenv("BOTDR_PLAYER_PASSWORD_SECRET_ARN")
MODULE_NAME = "Battle_Of_The_Dragons_Revived"
DEFAULT_MOD_LOCATION = os.path.expanduser("~/.local/share/Neverwinter Nights.0/modules")
NWSERVER_BINARY_DIR = "/nwserver/bin/linux-x86"
NWSERVER_BINARY = os.path.join(NWSERVER_BINARY_DIR, "nwserver-linux")
FIFO_PATH = "/tmp/nwserver_fifo"

# S3 client setup
logger.info("Setting up AWS clients...")
s3_client = boto3.client("s3")
sec_mgr_client = boto3.client("secretsmanager")

# Retrieve secrets
logger.info("Retrieving secrets...")
admin_password_secret = sec_mgr_client.get_secret_value(SecretId=BOTDR_ADMIN_PASSWORD_SECRET_ARN)
BOTDR_ADMIN_PASSWORD = admin_password_secret["SecretString"]
dm_password_secret = sec_mgr_client.get_secret_value(SecretId=BOTDR_DM_PASSWORD_SECRET_ARN)
BOTDR_DM_PASSWORD = dm_password_secret["SecretString"]
if APP_ENV == "dev":
    player_password_secret = sec_mgr_client.get_secret_value(SecretId=BOTDR_PLAYER_PASSWORD_SECRET_ARN)
    BOTDR_PLAYER_PASSWORD = player_password_secret["SecretString"]
else:
    BOTDR_PLAYER_PASSWORD = ""

logger.info("Begin NWN server startup process...")

def create_named_pipe():
    """
    Creates a named pipe (FIFO) if it doesn't exist.
    """
    if not os.path.exists(FIFO_PATH):
        logger.info("Creating named pipe...")
        os.mkfifo(FIFO_PATH)
        logger.info(f"Named pipe created at {FIFO_PATH}")

def init_nwserver():
    """
    Runs the nwserver binary to generate all required files
    """
    logger.info("Initializing NWN server...")
    subprocess.run([NWSERVER_BINARY, "-d"], cwd=NWSERVER_BINARY_DIR)

def download_mod_from_s3( S3Bucket: str, S3Key: str, DestinationDir: str) -> None:
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
        os.system(f"chmod +x \"{destination_path}\"")
        logger.info("Mod file permissions set successfully")
    except ClientError as e:
        logger.error("Error downloading mod from S3: %s", e)
        raise e

def verify_path_exists(Path: str, Description: str) -> bool:
    """
    Verifies whether a given path exists and logs an error if not.

    :param Path: The path to verify
    :param Description: Description of the resource for logging
    :return: True if the path exists, False otherwise
    """
    exists = os.path.exists(Path)
    if not exists:
        logger.error("%s does not exist: %s", Description, Path)
    return exists

def start_new_server(
    ModuleName: str,
    NwserverBinary: str,
    ModLocation: str,
    AdminPassword: str,
    DmPassword: str,
    PlayerPassword: str
    ) -> None:
    """
    Starts the NWN server with the specified module, redirecting stdin to the FIFO.
    """
    if not verify_path_exists(NwserverBinary, "NWN Server Binary"):
        return

    module_path = os.path.join(ModLocation, f"{ModuleName}.mod")
    if not verify_path_exists(module_path, "NWN Module"):
        return

    logger.info("Starting NWN server with named pipe for input...")

    # Start the nwserver process with stdin redirected to the FIFO
    nwserver_subprocess = [
        NwserverBinary,
        "-module", ModuleName,
        "-servername", "Battle Of The Dragons Revived BETA",
        "-maxclients", "32",
        "-minlevel", "1",
        "-maxlevel", "20",
        "-pauseandplay", "0",
        "-pvp", "1",
        "-servervault", "0",
        "-elc", "1",
        "-ilr", "1",
        "-gametype", "0",
        "-oneparty", "0",
        "-difficulty", "3",
        "-publicserver", "1",
        "-reloadwhenempty", "0",
        "-port", "5121"
    ]

    if APP_ENV == "dev":
        nwserver_subprocess.extend(
            [
                "-dmpassword", DmPassword,
                "-playerpassword", PlayerPassword,
                "-adminpassword", AdminPassword,
            ]
        )
    else:
        nwserver_subprocess.extend(
            [
                "-dmpassword", DmPassword,
                "-adminpassword", AdminPassword,
            ]
        )

    subprocess.run(nwserver_subprocess, cwd=NWSERVER_BINARY_DIR)

if __name__ == "__main__":
    # Create the named pipe
    create_named_pipe()

    # Initialize the NWN server
    init_nwserver()

    # Download the module
    download_mod_from_s3(
        S3Bucket=S3_BUCKET,
        S3Key=f"{MODULE_NAME}.mod",
        DestinationDir=DEFAULT_MOD_LOCATION
    )

    # Start the NWN server with named pipe support
    start_new_server(
        ModuleName=MODULE_NAME,
        NwserverBinary=NWSERVER_BINARY,
        ModLocation=DEFAULT_MOD_LOCATION,
        AdminPassword=BOTDR_ADMIN_PASSWORD,
        DmPassword=BOTDR_DM_PASSWORD,
        PlayerPassword=BOTDR_PLAYER_PASSWORD
    )
