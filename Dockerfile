FROM mhart/alpine-node:6

MAINTAINER Oz Haven (@therebelrobot) <dockerhub@therebelrobot.com>

# download yarn
ENV YARN_VERSION 0.21.3  
ADD https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v${YARN_VERSION}.tar.gz /opt/yarn.tar.gz

# make is needed for running docker locally
RUN apk update && apk add --no-cache make python g++

# install yarn
RUN yarnDirectory=/opt/yarn && \
    mkdir -p "$yarnDirectory" && \
    tar -xzf /opt/yarn.tar.gz -C "$yarnDirectory" && \
    ln -s "$yarnDirectory/dist/bin/yarn" /usr/local/bin/ && \
    rm /opt/yarn.tar.gz

# copy BrigadeHub projects
COPY ./distributions/suite ./suite
COPY ./core ./core
COPY ./themes/c4sf/public ./public
COPY ./themes/c4sf/admin ./admin

WORKDIR ./core
RUN make install
RUN make link

WORKDIR ./admin
RUN make install
RUN make link

WORKDIR ./public
RUN make install
RUN make link

WORKDIR ./suite

EXPOSE 5555

ENV PORT 5555
ENV NODE_ENV development

RUN make install
