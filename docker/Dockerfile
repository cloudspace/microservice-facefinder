FROM ruby:2.2.1
MAINTAINER Rusty Phillips <rusty@cloudspace.com>

# Doesn't take as long as adding opencv, but still takes a while.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install opencv-data bundler unzip cmake

RUN mkdir -p /srv/app
WORKDIR /srv/app/

# Add opencv first so that it never has to change since it takes forever.
ADD ./opencv.zip /srv/app/
ADD ./opencv-2.4.11.zip /srv/app/
RUN unzip opencv-2.4.11.zip
RUN mkdir /srv/app/opencv-2.4.11/release
WORKDIR /srv/app/opencv-2.4.11/release/
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..

RUN make
RUN make install

# The ruby stuff.
ADD ./Gemfile* /srv/app/

WORKDIR /srv/app
RUN bundle install

ADD ./haar_cascade.rb /srv/app/

CMD ["bundle","exec", "ruby", "/srv/app/haar_cascade.rb"]
