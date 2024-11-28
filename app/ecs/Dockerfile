# Use a base image
FROM nwnxee/unified:451aa94

ARG AWS_ENV
ARG AWS_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ENV=${AWS_ENV}

# Install AWS CLI
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install awscli

# Copy requirements.txt
COPY ./requirements.txt /nwn/home/requirements.txt

# Install requirements
RUN pip3 install -r /nwn/home/requirements.txt

RUN aws s3 cp s3://${AWS_ENV}-botdr-mod-bucket/Battle_Of_The_Dragons_Revived.mod /nwn/home/modules/Battle_Of_The_Dragons_Revived.mod

# Set up util scripts directory
RUN mkdir /nwn/home/util

EXPOSE 5121/udp
