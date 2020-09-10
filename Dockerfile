FROM google/cloud-sdk:251.0.0-alpine

ARG MYKE_VERSION=1.0.0
ARG DOCKER_VERSION=18.09.6
ARG HELM_VERSION=v3.2.4
ARG HELMFILE_VERSION=v0.125.0

RUN apk add openssl gettext jq

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

#helm
RUN curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz \
    && mv linux-amd64/helm /bin/helm \
    && rm -rf linux-amd64 \
    && helm version

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

#helmfile
RUN wget -qO /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && chmod +x /usr/local/bin/helmfile && helmfile --version

#helm-diff
RUN helm plugin install https://github.com/databus23/helm-diff

#ssh
RUN apk add nmap-ncat openssh rsync
