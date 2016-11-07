FROM ubuntu:14.04
MAINTAINER peter.amstutz@curoverse.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    python-setuptools gcc python-dev python-pip docker.io && \
    pip install -U setuptools && \
	apt-get -y autoremove && \
	apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install cwltool
ADD setup.py README.rst cwltool/ /root/cwltool/
ADD cwltool/ /root/cwltool/cwltool
ADD cwltool/schemas/ /root/cwltool/cwltool/schemas
RUN cd /root/cwltool && easy_install .

ENTRYPOINT ["/usr/local/bin/cwltool"]
