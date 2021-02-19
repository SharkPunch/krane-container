FROM ruby:3.0.0

ENV KUBECTL_VERSION=v1.18.2
ENV EJSON_VERSION=1.2.1
ENV KRANE_VERSION=1.1.3

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN gem install ejson -v $EJSON_VERSION
RUN gem install krane -v $KRANE_VERSION
