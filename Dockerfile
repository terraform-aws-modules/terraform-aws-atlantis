ARG CODE_VERSION=v0.15.0

FROM ubuntu:bionic
RUN apt-get update && apt-get install -y python3.6

FROM runatlantis/atlantis:${CODE_VERSION}
ARG SECRET_KEY_FILE
COPY --chown=root:atlantis ${SECRET_KEY_FILE} /home/atlantis/atlantis-app-key.pem
RUN chmod 644 /home/atlantis/atlantis-app-key.pem
