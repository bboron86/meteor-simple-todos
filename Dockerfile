FROM ubuntu:14.04

RUN apt-get update 
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update 
RUN apt-get install -y nodejs 

RUN apt-get install -y mongodb
RUN mkdir -p /data/db
VOLUME /data/db

RUN apt-get install -y git
RUN apt-get install -y curl
RUN curl https://install.meteor.com | /bin/sh

RUN mkdir -p /home/meteor/
WORKDIR /home/meteor
RUN git clone https://github.com/bboron86/meteor-simple-todos.git
WORKDIR meteor-simple-todos
RUN meteor build ../bundle

WORKDIR ../bundle
RUN tar -zxvf meteor-simple-todos.tar.gz
WORKDIR bundle/programs/server
RUN npm install

ENV PORT 80
ENV MONGO_URL mongodb://localhost:27017
ENV ROOT_URL http://ec2-52-29-32-82.eu-central-1.compute.amazonaws.com/

EXPOSE 80

CMD node /home/meteor/bundle/bundle/main.js
