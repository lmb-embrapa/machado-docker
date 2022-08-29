FROM openjdk:11

ARG USER
ARG UID

RUN useradd -m ${USER} -u ${UID}

ENV ES_PKG_NAME elasticsearch-7.17.6

RUN \
  cd / && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_NAME-linux-x86_64.tar.gz && \
  tar xvzf $ES_PKG_NAME-linux-x86_64.tar.gz && \
  rm -f $ES_PKG_NAME-linux-x86_64.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

RUN chmod -R 777 /elasticsearch
WORKDIR /elasticsearch

RUN sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /elasticsearch/config/elasticsearch.yml
RUN echo "discovery.type: single-node" >> /elasticsearch/config/elasticsearch.yml

CMD ["/elasticsearch/bin/elasticsearch"]

EXPOSE 9200
EXPOSE 9300
