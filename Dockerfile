FROM docker.io/alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0
ADD requirements.txt /tmp
ADD requirements.yml /tmp
RUN apk --no-cache add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git tar unzip zip && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev build-base
RUN pip3 install --break-system-packages --upgrade pip wheel && \
    pip3 install --break-system-packages --upgrade cryptography && \
    pip3 install --break-system-packages --ignore-installed -r /tmp/requirements.txt
RUN ansible-galaxy install -r /tmp/requirements.yml
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*  && \
    rm -rf /root/.cache/pip  && \
    rm -rf /root/.cargo