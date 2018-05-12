# Ansible & Testinfra Runner Container
# Provides the runtime for running ansible playbooks and tests with testinfra

FROM centos:centos7.4.1708

RUN yum install -q -y epel-release \
    && yum update -y \
    && yum install -q -y python-pip openssh-clients \
    && pip install --upgrade ansible==2.5.2 testinfra==1.10.1 virtualenv==15.1.0 ansible-lint==3.4.20 pytest==3.4.0 \
    && yum clean all -q \
    && useradd ansible \
    && mkdir /home/ansible/.ssh \
    && chown ansible:ansible /home/ansible/.ssh

COPY --chown=ansible:ansible id_rsa /home/ansible/.ssh/

USER ansible

ENV ANSIBLE_HOST_KEY_CHECKING=False
