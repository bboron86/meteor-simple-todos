FROM ubuntu:14.04

# install node js
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:chris-lea/node.js && \
  apt-get update && \
  apt-get install -y nodejs

# install meteor
RUN apt-get install -y git && \
  apt-get install -y curl && \
  curl https://install.meteor.com | /bin/sh

# copy sources to the container (jenkins did the clone already)
RUN mkdir -p /home/meteor/meteor-simple-todos
COPY . /home/meteor/meteor-simple-todos

# bundle meteor project
RUN cd /home/meteor/meteor-simple-todos && \
  meteor build ../bundle

# npm install server
RUN cd /home/meteor/bundle && \
  tar -zxvf meteor-simple-todos.tar.gz && \
  cd bundle/programs/server && \
  npm install

# set env parameters (mogo = name of the linked mongodb container)
ENV PORT 80
ENV MONGO_URL mongodb://mongo:27017
ENV ROOT_URL http://ec2-52-29-32-82.eu-central-1.compute.amazonaws.com/

# expose ports to host
EXPOSE 80

# start application on PID 1
CMD node /home/meteor/bundle/bundle/main.js