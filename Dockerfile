FROM mcr.microsoft.com/dotnet/runtime:9.0

ARG VERSION

# renovate: release=bullseye depName=curl
ENV CURL_VERSION=7.64.0-4+deb10u9
# renovate: release=bullseye depName=libsqlite3-0
ENV LIBSQLITE3_VERSION=3.27.2-3+deb10u2
# renovate: release=bullseye depName=mediainfo
ENV MEDIAINFO_VERSION=18.12-2

RUN apt-get update && \
    apt-get --assume-yes install \
        curl="${CURL_VERSION}" \
        libsqlite3-0="${LIBSQLITE3_VERSION}" \
        mediainfo="${MEDIAINFO_VERSION}" && \
    groupadd --gid=1000 radarr && \
    useradd --gid=1000 --home-dir=/opt/sonarr --no-create-home --shell /bin/bash --uid 1000 sonarr && \
    mkdir /config /downloads /series && \
    curl --location --output /tmp/sonarr.tar.gz "https://github.com/Sonarr/Sonarr/releases/download/v${VERSION}/Sonarr.main.${VERSION}.linux-x64.tar.gz" && \
    tar xzf /tmp/sonarr.tar.gz --directory=/opt/sonarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /series && \
    rm /tmp/sonarr.tar.gz

USER 1000
VOLUME /config /downloads /series
WORKDIR /opt/sonarr

EXPOSE 7878
CMD ["/opt/sonarr/Sonarr", "-data=/config", "-nobrowser"]
