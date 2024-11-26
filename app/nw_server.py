import subprocess
import time
import os
import sys

# Environment variables for directories
NWSERVER_BINARY_DIR = "/nwserver/bin/linux-x86"
NWNX_BINARY_DIR = "/nwserver/nwnxee"

# Adjust the path to your NWNX binary (verify the exact binary name)
NWNX_BINARY = "nwserver-linux"  # Change this if the binary has a different name

# Function to start the NWN server
def start_new_server():
    print("Starting NWN server with NWNX...")

    # Command to start the NWN server with the correct binary and options
    nwserver_subprocess = [
        f"{NWNX_BINARY_DIR}/{NWNX_BINARY}",  # Full path to the NWNX binary
        "-module", "YourModuleName",  # Replace with your module name
        "-publicserver", "1",  # Public server flag (optional)
    ]

    try:
        subprocess.run(nwserver_subprocess, cwd=NWSERVER_BINARY_DIR, check=True)
    except FileNotFoundError as e:
        print(f"Error: {e}")
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"Error: Failed to start NWN server - {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Ensure nwnx.ini is in the correct directory
    nwnx_ini_path = os.path.join(NWNX_BINARY_DIR, "nwnx.ini")
    if not os.path.exists(nwnx_ini_path):
        print(f"Error: {nwnx_ini_path} does not exist. Please ensure the configuration file is in place.")
        sys.exit(1)

    # Wait a few seconds for the configuration to be ready
    time.sleep(2)

    # Start the server
    start_new_server()
