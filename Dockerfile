FROM google/cloud-sdk

RUN \
    apt-get update \
    && apt-get -y install gettext-base jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

#helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get >get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && helm init --client-only

#myke
RUN curl -LO https://github.com/goeuro/myke/releases/download/v1.0.0/myke_linux_amd64 \
    && chmod +x myke_linux_amd64 \
    && mv myke_linux_amd64 /usr/local/bin/myke \
    && myke --version

#git
RUN git config --global user.email "support@opla.ai" \
    && git config --global user.name "CircleCI"

RUN sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"

