# Use a base image
FROM nwnxee/unified:451aa94

ARG BUILD_ENV
ARG AWS_REGION

RUN mkdir -p ~/.local/share/Neverwinter\ Nights/modules

RUN cp /tmp/Battle_Of_The_Dragons_Revived.mod ~/.local/share/Neverwinter\ Nights/modules

EXPOSE 5121/udp
