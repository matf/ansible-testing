# Ansible & Testinfra Runner Container
# Provides the runtime for running ansible playbooks and tests with testinfra

FROM centos:centos7.4.1708

RUN yum -q -y update ca-certificates \
    && yum install -q -y epel-release \
    && yum update -q -y \
    && yum install -q -y python-pip openssh-clients \
    && pip install --upgrade ansible==2.5.2 testinfra==1.13.0 virtualenv==15.1.0 ansible-lint==3.4.20 pytest==3.4.0 \
    && yum clean all -q \
    && useradd ansible \
    && mkdir /home/ansible/.ssh \
    && chown ansible:ansible /home/ansible/.ssh

COPY --chown=ansible:ansible id_rsa /home/ansible/.ssh/

USER ansible

# The target container is re-created for every run, so there is not point in checking its identity
ENV ANSIBLE_HOST_KEY_CHECKING=False
