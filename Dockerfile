FROM ubuntu:14.04

# install node js
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:chris-lea/node.js && \
  apt-get update && \
  apt-get install -y nodejs

# install mongodb
RUN apt-get install -y mongodb && \
  mkdir -p /data/db
VOLUME /data/db

# install meteor
RUN apt-get install -y git && \
  apt-get install -y curl && \
  curl https://install.meteor.com | /bin/sh

# bundle meteor project
RUN mkdir -p /home/meteor/ && \
  cd /home/meteor && \
  git clone https://github.com/bboron86/meteor-simple-todos.git && \
  cd meteor-simple-todos && \
  meteor build ../bundle

# npm install server
RUN cd /home/meteor/bundle && \
  tar -zxvf meteor-simple-todos.tar.gz && \
  cd bundle/programs/server && \
  npm install

# set env parameters
ENV PORT 80
ENV MONGO_URL mongodb://localhost:27017
ENV ROOT_URL http://ec2-52-29-32-82.eu-central-1.compute.amazonaws.com/

# expose ports to host
EXPOSE 80

# start application on PID 1
CMD node /home/meteor/bundle/bundle/main.js