FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11
ADD requirements.txt /tmp
ADD requirements.yml /tmp
RUN apk --no-cache add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git tar unzip zip && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev build-base
RUN pip3 install --break-system-packages --upgrade pip wheel && \
    pip3 install --break-system-packages --upgrade cryptography && \
    pip3 install --break-system-packages --ignore-installed -r /tmp/requirements.txt
RUN ansible-galaxy install -r /tmp/requirements.yml
COPY --from=docker.io/tailscale/tailscale:v1.98.3@sha256:854b77123b9536adae2e97f5a5fdb1790ed03438b911ab7f07780155e0af6ce2 /usr/local/bin/tailscaled /usr/local/bin/tailscale /usr/local/bin/
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*  && \
    rm -rf /root/.cache/pip  && \
    rm -rf /root/.cargo