FROM ubuntu:14.04
MAINTAINER dion@transition9.com


# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    python-setuptools gcc python-dev wget unzip

# Install cwltool
ADD setup.py README.rst cwltool/ /root/cwltool/
ADD cwltool/ /root/cwltool/cwltool
ADD cwltool/schemas/ /root/cwltool/cwltool/schemas
ADD tests/ /root/cwltool/tests
RUN cd /root/cwltool && python setup.py install

ENV PYTHONPATH /root

#Add utils for running workflows downloaded from git
ADD bin /root/bin

# ENTRYPOINT []
