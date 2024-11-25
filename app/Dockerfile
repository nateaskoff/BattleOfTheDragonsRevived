# Use a base image
#checkov:skip=CKV_DOCKER_2:no way to do health check with nwserver
FROM ubuntu:22.04

# Install dependencies and clean up cache
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget unzip python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV HOME=/home/nwserver-user
ENV NWN_SERVER_DIR=/nwserver/bin/linux-x86

# Install Python requirements
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r /tmp/requirements.txt

# Create nwserver-user with a home directory and set permissions
RUN useradd nwserver-user -s /bin/bash -m -d ${HOME} && \
    mkdir -p ${HOME}/.local/share/Neverwinter\ Nights/modules/ && \
    mkdir -p ${NWN_SERVER_DIR} && \
    chown -R nwserver-user:nwserver-user ${HOME} ${NWN_SERVER_DIR}

# Download NWN:EE server for Linux and extract it
RUN wget -O /tmp/nwserver-linux.zip https://nwn.beamdog.net/downloads/nwnee-dedicated-8193.34.zip && \
    unzip /tmp/nwserver-linux.zip -d /nwserver && \
    rm /tmp/nwserver-linux.zip && \
    chown -R nwserver-user:nwserver-user /nwserver

# Copy the server script into the user's home directory
COPY nw_server.py ${HOME}/nw_server.py
RUN chmod 755 ${HOME}/nw_server.py && \
    chown nwserver-user:nwserver-user ${HOME}/nw_server.py

# Copy the deployment notification script into the user's home directory
COPY botdr_deploy_notification.sh ${HOME}/botdr_deploy_notification.sh
RUN chmod 755 ${HOME}/botdr_deploy_notification.sh && \
    chown nwserver-user:nwserver-user ${HOME}/botdr_deploy_notification.sh && \
    chmod +x ${HOME}/botdr_deploy_notification.sh

# Set the working directory
WORKDIR ${HOME}

# Switch to nwserver-user
USER nwserver-user

# Expose port 5121 for UDP traffic
EXPOSE 5121/udp

# Command to start the server script
CMD ["python3", "./nw_server.py"]
