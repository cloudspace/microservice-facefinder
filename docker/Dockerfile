FROM dockerfile/ruby
MAINTAINER Rusty Phillips <rusty@cloudspace.com>

# Doesn't take as long as adding opencv, but still takes a while.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install opencv-data bundler cmake libopencv-dev

# RUN mkdir -p /srv/app
# WORKDIR /srv/app/

# Add opencv first so that it never has to change since it takes forever.
#ADD ./opencv.zip /srv/app/
#ADD http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.9/opencv-2.4.9.zip /srv/app/
#RUN unzip opencv-2.4.9.zip
#RUN mkdir /srv/app/opencv-2.4.9/release
#WORKDIR /srv/app/opencv-2.4.9/release/
#RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..

#RUN make
#RUN make install

# The ruby stuff.
ADD ./Gemfile* /data/
COPY ./lib/* /data/lib/
RUN bundle install

COPY ./haar_cascade.rb /data/

ADD ./microservice.yml /microservice.yml

CMD ["bundle","exec", "ruby", "/data/haar_cascade.rb"]

