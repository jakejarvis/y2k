FROM docker.io/ubuntu:20.04

LABEL maintainer="Jake Jarvis <jake@jarv.is>"
LABEL repository="https://github.com/jakejarvis/y2k"
LABEL homepage="https://y2k.app/"

ARG DEBIAN_FRONTEND=noninteractive

# corrects the time inside the Windows VM, if tzdata is installed below
ENV TZ=America/New_York

# do everything as an unprivileged user :)
RUN useradd -m vm

# copy boot script and Windows HDD (must be at ./container/hdd/hdd.img)
COPY container/bin/boot.rb /usr/local/bin/boot-vm
COPY --chown=vm container/hdd/hdd.img /home/vm/hdd.img

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
        tzdata \
        ruby \
        qemu-system-x86 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /usr/local/bin/boot-vm \
 && ls -lah /home/vm \
 # make sure everything's okay so far
 && qemu-system-i386 --version \
 && ruby --version

# ----
# TODO: make *each container* a websockets server so we can load balance, etc.

# ENV WEBSOCKETD_VERSION 0.3.1
# RUN wget https://github.com/joewalnes/websocketd/releases/download/v${WEBSOCKETD_VERSION}/websocketd-${WEBSOCKETD_VERSION}-linux_amd64.zip \
#  && unzip websocketd-${WEBSOCKETD_VERSION}-linux_amd64.zip \
#  && chmod +x websocketd \
#  && mv websocketd /usr/local/bin/

# RUN websocketd --version

# EXPOSE 80
# ----

# bye bye root <3
USER vm
WORKDIR /home/vm

ENTRYPOINT ["boot-vm"]
