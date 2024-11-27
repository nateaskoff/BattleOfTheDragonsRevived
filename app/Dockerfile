# Use a base image
FROM ubuntu:22.04

# Install dependencies and clean up cache
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget unzip python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV HOME=/home/nwserver-user
ENV NWN_SERVER_DIR=/nwserver
ENV NWNX_DIR=/nwserver/bin/linux-x86
ENV LD_PRELOAD="${NWNX_DIR}/NWNX_Core.so"  # For loading the NWNX core plugin

# Install Python requirements
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r /tmp/requirements.txt

# Create nwserver-user with a home directory and set permissions
RUN useradd nwserver-user -s /bin/bash -m -d ${HOME} && \
    mkdir -p ${HOME}/.local/share/Neverwinter\ Nights/modules/ && \
    mkdir -p ${NWN_SERVER_DIR} && \
    chown -R nwserver-user:nwserver-user ${HOME} ${NWN_SERVER_DIR}

# Download and extract NWN:EE server for Linux into its default directory
RUN wget -O /tmp/nwserver-linux.zip https://nwn.beamdog.net/downloads/nwnee-dicated-8193.34.zip && \
    unzip /tmp/nwserver-linux.zip -d /nwserver && \
    rm /tmp/nwserver-linux.zip && \
    chown -R nwserver-user:nwserver-user /nwserver

# Download and extract NWNXEE into its correct directory
RUN wget -O /tmp/nwnxee.zip https://github.com/nwnxee/unified/releases/download/latest/NWNX-EE.zip && \
    unzip /tmp/nwnxee.zip -d /nwserver/bin/linux-x86 && \
    rm /tmp/nwnxee.zip && \
    chown -R nwserver-user:nwserver-user /nwserver/bin/linux-x86

# Copy the server script into the user's home directory
COPY nw_server.py ${HOME}/nw_server.py
RUN chmod 755 ${HOME}/nw_server.py && \
    chown nwserver-user:nwserver-user ${HOME}/nw_server.py

# Copy the deployment notification script into the user's home directory
COPY botdr_deploy_notification.sh ${HOME}/botdr_deploy_notification.sh
RUN chmod 755 ${HOME}/botdr_deploy_notification.sh && \
    chown nwserver-user:nwserver-user ${HOME}/botdr_deploy_notification.sh && \
    chmod +x ${HOME}/botdr_deploy_notification.sh

# Copy the nwnx.ini config into the correct directory
COPY nwnx.ini ${NWN_SERVER_DIR}/nwnx.ini

# Create a startup script to preload NWNX_Core.so and start the server
COPY start_server.sh ${HOME}/start_server.sh
RUN chmod +x ${HOME}/start_server.sh && \
    chown nwserver-user:nwserver-user ${HOME}/start_server.sh

# Set the working directory
WORKDIR ${HOME}

# Switch to nwserver-user
USER nwserver-user

# Expose port 5121 for UDP traffic
EXPOSE 5121/udp

# Command to start the server using the startup script
CMD ["./start_server.sh"]
