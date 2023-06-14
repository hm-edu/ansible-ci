FROM docker.io/alpine:3.18.2@sha256:25fad2a32ad1f6f510e528448ae1ec69a28ef81916a004d3629874104f8a7f70
ADD requirements.txt /tmp
ADD requirements.yml /tmp
RUN apk --no-cache add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git tar unzip zip && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev build-base
RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography && \
    pip3 install --ignore-installed -r /tmp/requirements.txt
RUN ansible-galaxy install -r /tmp/requirements.yml
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*  && \
    rm -rf /root/.cache/pip  && \
    rm -rf /root/.cargo