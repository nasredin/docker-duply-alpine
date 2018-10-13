FROM alpine:latest
RUN echo 'http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories 
RUN apk update
RUN apk add bash \
        duply \
        py2-pip \
        haveged \
        ncftp \
        py-boto \
        py2-paramiko \
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
