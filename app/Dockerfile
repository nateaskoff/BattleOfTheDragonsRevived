# Use a base image
FROM nwnxee/unified:451aa94

ARG BUILD_ENV
ARG AWS_REGION

# Use full path instead of ~ to avoid issues with tilde expansion
RUN mkdir -p /root/.local/share/Neverwinter\ Nights/modules

COPY ./tmp/Battle_Of_The_Dragons_Revived.mod /root/.local/share/Neverwinter\ Nights/modules

EXPOSE 5121/udp
