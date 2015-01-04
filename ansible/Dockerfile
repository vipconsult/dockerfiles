FROM debian
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get -y update && \
    apt-get install -y \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    python-pkg-resources \
    git \
    python-pip \
    openssh-server \
    nano

RUN mkdir /var/run/sshd
RUN mkdir -p  /root/.ssh && echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAoO4JyFCtuSxr+MUqidLcWAkSO2cqtjFdiuZOxHetyFmq+ElyxDSfNIhuXKJJmuzksl19s/RqPo4EBBwL+24SH/fFTKWYb+kK1IQfH2cQS8A3K2rcn5iGbgHP+hktwABh9ZQdsIyZCcb+aG8+odRQrDnrkKs+Se10maa4wH/517a0C+e+T9ZyHCHFHNi7N3Vj/OIdLLGKdgIuo2bpWJwURqTBbpLZQJXcbcCg43LGW4Bk3ZHGQAWvKmnQLBKBD7Ns8mF+ApKHJMIIsrR060GwE8RPdsLoUo+dIAm4lAWpYSjIm+LEGFfcEyNXBrHZJbMvJHzjWCnukLJOgHDW6ZxW5Q==' > /root/.ssh/authorized_keys
#RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get purge --auto-remove -y python2.6 python2.6-minimal
RUN mkdir /etc/ansible/
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN mkdir /usr/local/ansible
RUN git clone http://github.com/ansible/ansible.git --recursive /usr/local/ansible
WORKDIR /usr/local/ansible
RUN /bin/bash -c "source ./hacking/env-setup"
RUN make install

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

