FROM ruby:latest
MAINTAINER Rusty Phillips <rusty@cloudspace.com>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install opencv-data bundler unzip cmake

RUN mkdir -p /srv/app
WORKDIR /srv/app

ADD ./opencv-2.4.11.zip /srv/app/
ADD ./Gemfile* /srv/app/
ADD ./haar_cascade.rb /srv/app/

RUN unzip opencv-2.4.11.zip
RUN mkdir /srv/app/opencv-2.4.11/release
WORKDIR /srv/app/opencv-2.4.11/release

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
RUN make
RUN make install
WORKDIR /srv/app
RUN bundle install

CMD ["bundle","exec", "ruby", "/srv/app/haar_cascade.rb"]
