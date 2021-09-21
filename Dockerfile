FROM ruby:3.0.2

ENV KUBECTL_VERSION=v1.20.2
ENV EJSON_VERSION=1.2.2
ENV KRANE_VERSION=2.1.6

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -L https://github.com/Shopify/ejson/releases/download/v${EJSON_VERSION}/ejson-${EJSON_VERSION}.gem \
  -o ejson-${EJSON_VERSION}.gem \
  && gem install --local ejson-${EJSON_VERSION}.gem
RUN gem install krane -v $KRANE_VERSION
