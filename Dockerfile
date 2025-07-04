#
# TinyMediaManager Dockerfile
#
FROM jlesage/baseimage-gui:alpine-3.12-glibc

# Define software versions.
ARG TMM_VERSION=5.1.7

# Define software download URLs.
ARG TMM_URL=https://release.tinymediamanager.org/v5/dist/tinyMediaManager-${TMM_VERSION}-linux-amd64.tar.xz
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jre/bin

# Define working directory.
WORKDIR /tmp

# Download TinyMediaManager
RUN \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.xz

# Install dependencies.
RUN \
    apk add --update \
        libmediainfo \
        ttf-dejavu \
        bash \
        zenity \
        tar \
      	zstd \
        fontconfig \
        ttf-dejavu


# Fix Java Segmentation Fault
#RUN wget "https://www.archlinux.org/packages/core/x86_64/zlib/download" -O /tmp/libz.tar.xz \
#    && mkdir -p /tmp/libz \
#    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
#    && cp /tmp/libz/usr/lib/libz.so.1.3.1 /usr/glibc-compat/lib \
#    && /usr/glibc-compat/sbin/ldconfig \
#    && rm -rf /tmp/libz /tmp/libz.tar.xz

# Maximize only the main/initial window.
# It seems this is not needed for TMM 3.X version.
#RUN \
#    sed-patch 's/<application type="normal">/<application type="normal" title="tinyMediaManager \/ 3.0.2">/' \
#        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://gitlab.com/tinyMediaManager/tinyMediaManager/raw/45f9c702615a55725a508523b0524166b188ff75/AppBundler/tmm.png

# Install Chinese fonts
RUN wget -O /tmp/font.tar.gz http://downloads.sourceforge.net/wqy/wqy-zenhei-0.9.45.tar.gz && \
    tar -xzvf /tmp/font.tar.gz -C /tmp/ && \
    mkdir -p /usr/share/fonts/truetype/wqy && \
    cp /tmp/wqy-zenhei/wqy-zenhei.ttc /usr/share/fonts/truetype/wqy/ && \
    fc-cache -f -v && \
    rm -rf /tmp/font.tar.gz /tmp/wqy-zenhei

# Add files.
COPY rootfs/ /
COPY VERSION /

# Set environment variables.
ENV APP_NAME="TinyMediaManager" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

# Metadata.
LABEL \
      org.label-schema.name="tinymediamanager" \
      org.label-schema.description="Docker container for TinyMediaManager" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/FunnyFly-ZW/tinymediamanager5-docker" \
      org.label-schema.schema-version="1.0"
