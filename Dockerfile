FROM alpine:edge
RUN echo 'http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories 

# trickle
#  work around issue #16:  https://github.com/mariusae/trickle/issues/16
ENV TRICKLE_VERSION=596bb13f2bc323fc8e7783b8dcba627de4969e07
ENV TRICKLE_SHA256SUM=a4111063d67a3330025eea2f29ebd8c8605e43cc1be0bf384b48f0eab8daf508

RUN set -eux; \
    apk add --no-cache libcurl libtirpc-dev libevent \
    && apk add --no-cache --virtual .build-deps curl make automake autoconf libtool alpine-sdk libevent-dev; \
    cd /tmp; \
    curl -L -o trickle.tgz https://github.com/mariusae/trickle/archive/${TRICKLE_VERSION}.tar.gz; \
    echo "$TRICKLE_SHA256SUM  trickle.tgz" | sha256sum -c -; \
    tar xvzf trickle.tgz; \
    cd "trickle-${TRICKLE_VERSION}"; \
    export CFLAGS=-I/usr/include/tirpc; \
    export LDFLAGS=-ltirpc; \
    autoreconf -if; \
    ./configure; \
    make install-exec-am install-trickleoverloadDATA; \
    rm -rf /tmp/*; \
    apk del .build-deps;
RUN apk update
RUN apk add bash \
        duply \
        py-pip \
        haveged \
	py-paramiko \
        ncftp \
        py-boto \
        pwgen \
        rsync \
        openssh-client \
        megatools&& pip install --upgrade pip
RUN pip install pydrive
ENV HOME /root
ENV HOSTNAME duply-backup
ENV KEY_TYPE      RSA
ENV KEY_LENGTH    2048
ENV SUBKEY_TYPE   RSA
ENV SUBKEY_LENGTH 2048
ENV NAME_REAL     Duply Backup
ENV NAME_EMAIL    duply@localhost
ENV PASSPHRASE    random
ENV GOOGLE_DRIVE_SETTINGS /root/pydrive.conf
ENV GPG_OPTS '--pinentry-mode loopback'
VOLUME ["/root"]

COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
