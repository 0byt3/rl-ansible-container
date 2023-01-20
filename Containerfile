FROM docker.io/rockylinux:9-minimal
LABEL version=0.1

# the home dir user making use of this container
ARG user_home
ARG term_var=xterm-256color

ENV USER_HOME ${user_home}
ENV TERM ${term_var}

# RUN apt update && apt -y install ieee-data libyaml-0-2 krb5-config libkrb5-dev krb5-doc krb5-user
RUN microdnf -y install gcc krb5-devel krb5-libs openssh-clients procps python3 python3-devel python3-pip sshpass vim which

## install ansible
RUN pip3 install pysetup wheel
RUN pip3 install ansible-pylibssh apache-libcloud awk jinja2 jmespath kerberos lockfile markupsafe netaddr ntlm-auth pandevice pan-python pan-os-python pypsexec requests-credssp requests-kerberos requests-ntlm simplejson smbprotocol[kerberos] pywinrm pywinrm[credssp] sed xmltodict pyyaml
RUN pip3 install ansible

## add collections
RUN ansible-galaxy collection install arubanetworks.aos_switch
RUN ansible-galaxy collection install ansible.netcommon ansible.windows
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.crypto
RUN ansible-galaxy collection install community.general
RUN ansible-galaxy collection install community.network
RUN ansible-galaxy collection install community.windows
RUN ansible-galaxy collection install paloaltonetworks.panos
RUN ansible-galaxy collection install pfsensible.core

## create dir to hold volume
RUN test -d /mnt/home || mkdir -p /mnt/home

## create dir for init script
RUN test -d /scripts || mkdir /scripts

## copy the container init file
COPY container-init.bash /scripts/
RUN chmod a+x /scripts/container-init.bash

## add bash profile for root
COPY bash_rc /root/.bash_rc
COPY bash_profile /root/.profile

# ENTRYPOINT /usr/bash /scripts/container-init.bash