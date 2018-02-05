#################################################################
# Base image
#################################################################
FROM ubuntu:xenial as base
MAINTAINER matthew@nettaylor.com 

RUN \
  apt-get update && \
  apt-get install -y software-properties-common python-software-properties python3-pip iputils-ping && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#################################################################
# Builder image
#################################################################
FROM base as builder

RUN apt-get update && apt-get install -y \
        git \
        maven \
        unzip \
    && rm -rf /var/lib/apt/lists/*

#################################################################
# Runtime image
#################################################################
FROM base

RUN apt-get update
RUN apt-get install python3-virtualenv
RUN pip3 install --upgrade pip
RUN pip3 install pandas 
RUN pip3 install scikit-learn 
RUN pip3 install scipy
RUN pip3 install spacy
RUN pip3 install --upgrade tensorflow

# Expose transport ports
EXPOSE 8080 8443

#CMD ["/opt/wso2is/bin/wso2server.sh"]
