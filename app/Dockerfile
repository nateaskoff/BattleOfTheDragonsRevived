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

RUN mkdir server
RUN mkdir server/modules

RUN aws s3 cp s3://${AWS_ENV}-botdr-mod-bucket/Battle_Of_The_Dragons_Revived.mod server/modules/Battle_Of_The_Dragons_Revived.mod

EXPOSE 5121/udp
