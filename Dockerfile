FROM ubuntu:14.04

# install node js
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:chris-lea/node.js && \
  apt-get update && \
  apt-get install -y nodejs

# install mongodb
RUN apt-get install -y mongodb
RUN mkdir -p /data/db
VOLUME /data/db

# install meteor
RUN apt-get install -y git
RUN apt-get install -y curl
RUN curl https://install.meteor.com | /bin/sh

# bundle meteor project
RUN mkdir -p /home/meteor/
WORKDIR /home/meteor
RUN git clone https://github.com/bboron86/meteor-simple-todos.git
WORKDIR meteor-simple-todos
RUN meteor build ../bundle

# npm install server
WORKDIR ../bundle
RUN tar -zxvf meteor-simple-todos.tar.gz
WORKDIR bundle/programs/server
RUN npm install

# set env parameters
ENV PORT 80
ENV MONGO_URL mongodb://localhost:27017
ENV ROOT_URL http://ec2-52-29-32-82.eu-central-1.compute.amazonaws.com/

# expose ports to host
EXPOSE 80

# start application on PID 1
CMD node /home/meteor/bundle/bundle/main.js