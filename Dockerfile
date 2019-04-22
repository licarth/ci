FROM google/cloud-sdk:alpine

ARG MYKE_VERSION=1.0.0
ARG DOCKER_VERSION=17.03.0-ce

RUN apk add openssl gettext jq

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

#helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get >get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && helm init --client-only \
    && rm get_helm.sh

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
    && mv /tmp/docker/* /usr/local/bin/

RUN apk add --no-cache --update nodejs nodejs-npm
