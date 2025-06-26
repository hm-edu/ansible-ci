FROM docker.io/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715
ADD requirements.txt /tmp
ADD requirements.yml /tmp
RUN apk --no-cache add sudo python3 py3-pip openssl ca-certificates sshpass openssh-client rsync git tar unzip zip && \
    apk --no-cache add --virtual build-dependencies python3-dev libffi-dev musl-dev gcc cargo openssl-dev build-base
RUN pip3 install --break-system-packages --upgrade pip wheel && \
    pip3 install --break-system-packages --upgrade cryptography && \
    pip3 install --break-system-packages --ignore-installed -r /tmp/requirements.txt
RUN ansible-galaxy install -r /tmp/requirements.yml
COPY --from=docker.io/tailscale/tailscale:v1.84.3@sha256:f97ea471667bd94023f76e228c5be0b95564cdba2f9501cb084eeef139d8b65e /usr/local/bin/tailscaled /usr/local/bin/tailscale /usr/local/bin/
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*  && \
    rm -rf /root/.cache/pip  && \
    rm -rf /root/.cargo