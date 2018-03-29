# Ansible & Testinfra Runner Container
# Provides the runtime for running ansible playbooks and tests with testinfra

FROM centos:centos7.4.1708

RUN yum install -q epel-release -y \
    && yum update -y \
    && yum install -q ansible-2.4.2.0 python-pip -y \
    && pip install --upgrade testinfra==1.10.1 virtualenv==15.1.0 ansible-lint==3.4.20 pytest==3.4.0 \
    && yum clean all -q \
    && useradd ansible

USER ansible
