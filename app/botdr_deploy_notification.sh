#!/bin/bash

FIFO_PATH="/tmp/nwserver_fifo"

# Check if the FIFO exists
if [ ! -p "$FIFO_PATH" ]; then
    echo "Error: FIFO path $FIFO_PATH does not exist."
    exit 1
fi

# Send a command to the NWN server via the FIFO
echo "say ECS EXEC TEST" > "$FIFO_PATH" && echo "Command sent successfully." || echo "Failed to send command."
