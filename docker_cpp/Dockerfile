FROM gliderlabs/alpine:3.1
MAINTAINER Rusty Phillips <rusty@cloudspace.com>

# Doesn't take as long as adding opencv, but still takes a while.
RUN apk --update add curl

RUN mkdir /data
ADD ./haarcascade_frontalface_alt.xml /haarcascade_frontalface_alt.xml
ADD ./detectFaces /detectFaces
ADD ./detectFaces.sh /detectFaces.sh
ADD ./microservice.yml /microservice.yml

CMD [ ./detectFaces.sh ]

