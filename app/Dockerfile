# Use a base image
FROM nwnxee/unified:451aa94

RUN apt-get update && apt-get install -y awscli

ARG BUILD_ENV
ARG AWS_REGION

RUN mkdir -p ~/.local/share/Neverwinter\ Nights/modules

RUN aws s3 cp s3://${BUILD_ENV}-botdr-mod-bucket/Battle_Of_The_Dragons_Revived.mod ~/.local/share/Neverwinter\ Nights/modules/

EXPOSE 5121/udp
