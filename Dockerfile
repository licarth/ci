FROM google/cloud-sdk:251.0.0-alpine

ARG MYKE_VERSION=1.0.0
ARG DOCKER_VERSION=18.09.6
ARG HELM_VERSION=v2.14.0
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN apk add openssl gettext jq

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

#helm
RUN curl -L https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar xz \
    && mv linux-amd64/helm /bin/helm \
    && rm -rf linux-amd64 \
    && helm init --client-only

#myke
RUN curl -LO https://github.com/goeuro/myke/releases/download/v${MYKE_VERSION}/myke_linux_amd64 \
    && chmod +x myke_linux_amd64 \
    && mv myke_linux_amd64 /usr/local/bin/myke \
    && myke --version

#retry
RUN sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"

#docker 
RUN curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
    && mv /tmp/docker/* /usr/local/bin/ && docker version || true

#circleci CLI
RUN curl -fLSs https://circle.ci/cli | bash

#npm
RUN apk add --no-cache --update nodejs nodejs-npm

RUN gcloud components install beta cloud_sql_proxy

