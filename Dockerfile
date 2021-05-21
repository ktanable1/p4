FROM centos:7
MAINTAINER kenji_tan

ENV P4PORT ssl:p4.example.com:1666

COPY p4_* /bin

RUN yum install -y epel-release && \
    yum groupinstall -y 'development tools' && \
    rpm --import https://package.perforce.com/perforce.pubkey

RUN echo -e '\n\
[Perforce] \n\
name=Perforce \n\
baseurl=http://package.perforce.com/yum/rhel/7/x86_64/ \n\
enabled=1 \n\
gpgcheck=1 \n\
' \
>> /etc/yum.repos.d/perforce.repo

RUN yum install -y python-pip python-devel perforce-cli helix-cli perforce-p4python && \
    pip install progressbar2

WORKDIR /workspace
RUN adduser vagrant
RUN chown -R vagrant:vagrant /workspace

USER vagrant
RUN echo P4PORT: [$P4PORT]
RUN p4 -p $P4PORT trust -y
