# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.17

ARG BUILD_DATE
ARG VERSION
ARG TASKWARRIOR_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="absolutelink"

ENV \
  HOME=/config

RUN \
  apk add --update --no-cache curl && \
  mkdir -p /app/taskwarrior && \
  if [ -z ${TASKWARRIOR_RELEASE+x} ]; then \
    TASKWARRIOR_RELEASE_URL=$(curl -sX GET "https://api.github.com/repos/GothenburgBitFactory/taskwarrior/releases/latest" \
    | awk '/tarball_url/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "*** Installing Taskwarrior ***" && \
  curl -o \
    /tmp/taskwarrior.tar.gz -L \
    "${TASKWARRIOR_RELEASE_URL}" && \
  tar xzf \
    /tmp/taskwarrior.tar.gz --strip-components 1 -C \
    /app/taskwarrior/ && \
  echo "*** Cleaning Up ***" && \
  rm /tmp/taskwarrior.tar.gz

COPY /root /

EXPOSE 8080

VOLUME /config