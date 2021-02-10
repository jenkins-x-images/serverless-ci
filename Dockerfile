FROM node:14.15.4-alpine3.12

# Based on https://github.com/serverlesspolska/serverless-framework-docker-image/blob/master/Dockerfile
ENV GLIBC_VER=2.32-r0
RUN apk --no-cache add \
        python3 \
        build-base \
        alpine-sdk \
        jq \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*
    
# Install Serverless Framework
WORKDIR /app
ENV PATH=$PATH:/app/.npm-global/bin
ENV NPM_CONFIG_PREFIX=/app/.npm-global
RUN npm config set user root && \
    npm install -g serverless@2.22.0
RUN aws --version && \
    serverless --version && \
    jq --version


LABEL org.opencontainers.image.source https://github.com/jenkins-x-images/serverless-ci
