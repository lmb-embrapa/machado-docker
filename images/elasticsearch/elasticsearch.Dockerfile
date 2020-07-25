FROM openjdk:8

ENV ES_PKG_NAME elasticsearch-5.6.16

RUN \
  cd / && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

RUN chmod -R 777 /elasticsearch
WORKDIR /elasticsearch

CMD ["/elasticsearch/bin/elasticsearch"]

EXPOSE 9200
EXPOSE 9300
