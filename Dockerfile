FROM docker:17.12.0-ce as static-docker-source

FROM debian:jessie

RUN apt-get -qqy update && apt-get install -qqy \
    curl \
    bash \
    openssl

#docker
COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
# RUN curl -fsSL https://get.docker.com -o get-docker.sh \
#     && sh get-docker.sh

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

#helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get >get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

#myke
RUN curl -LO https://github.com/goeuro/myke/releases/download/v1.0.0/myke_linux_amd64 \
&& chmod +x myke_linux_amd64 \
    && mv myke_linux_amd64 /usr/local/bin/myke \
    && myke --version
