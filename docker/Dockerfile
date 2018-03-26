# API Simulator Dockerfile

# Ubuntu-based
FROM openjdk:8u162-jre-slim

MAINTAINER http://apisimulator.io/

# Pass in as build argument instead. For example:
# --build-arg APISIMULATOR_VERSION=0.9.0
#ENV APISIMULATOR_VERSION 0.9.0
ARG  APISIMULATOR_VERSION

# Download and install API Simulator
RUN apt-get update \
 && apt-get -y install ca-certificates wget \
 && wget -P . https://apisimulator.io/downloads/apisimulator-http-$APISIMULATOR_VERSION-distro.zip \
 && unzip apisimulator-http-$APISIMULATOR_VERSION-distro.zip -d . \
 && rm -f apisimulator-http-$APISIMULATOR_VERSION-distro.zip \
 && addgroup --system --gid 10101 apisimulator \
 && adduser --system --disabled-password --uid 10101 --shell /usr/sbin/nologin --home /apisimulator --ingroup apisimulator apisimulator \
 && chown -R apisimulator:root /apisimulator \
 && chmod -R 0775 /apisimulator \
 && apt-get clean

EXPOSE 6090/tcp

WORKDIR /apisimulator/apisimulator-http-$APISIMULATOR_VERSION

ENV PATH /apisimulator/apisimulator-http-$APISIMULATOR_VERSION/bin:$PATH

USER 10101

CMD ["echo", "Visit apisimulator.io for how to use this image to run API Simulator or API Recorder"]
# @END
