FROM docker.io/alpine:3.17.3@sha256:b6ca290b6b4cdcca5b3db3ffa338ee0285c11744b4a6abaa9627746ee3291d8d
ADD requirements.txt /tmp
RUN apk --no-cache add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev build-base
RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography && \
    pip3 install --ignore-installed -r /tmp/requirements.txt
RUN ansible-galaxy collection install community.docker:3.4.3 && \
    ansible-galaxy collection install community.general:6.5.0
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*  && \
    rm -rf /root/.cache/pip  && \
    rm -rf /root/.cargo