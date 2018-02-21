# build:
# docker build -t f3ex/ansible-gcp:0.1 .
# or
# docker build -t f3ex/ansible-gcp .

FROM ubuntu:16.04

LABEL maintainer="Aleksey Stepanenko"

RUN apt update && apt install -y git python-pip python-dev python-crypto && \
    pip install virtualenv pycrypto && \
    pip install --upgrade pip && \
    virtualenv -p python2.7 /env && \
    . /env/bin/activate && \
    pip install ansible apache-libcloud PyCrypto

CMD [ "/bin/bash" ]
