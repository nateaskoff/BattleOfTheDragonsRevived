# Use a base image
FROM nwnxee/unified:451aa94

ARG AWS_ENV
ARG AWS_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_ENV=${AWS_ENV}

RUN aws s3 cp s3://${AWS_ENV}-botdr-mod-bucket/Battle_Of_The_Dragons_Revived.mod /modules/Battle_Of_The_Dragons_Revived.mod

EXPOSE 5121/udp
