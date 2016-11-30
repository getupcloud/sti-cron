FROM openshift/base-centos7

# This image provides a Ruby 1.9 environment you can use to run your Ruby
# applications.

MAINTAINER Mateus Caruccio <mateus.caruccio@getupcloud.com>

ENV CRON_VERSION 1.0

LABEL io.k8s.description="Base image for cron-based containers" \
      io.k8s.display-name="Cron 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,cron,cron1"

RUN INSTALL_PKGS="cronie crontabs nss_wrapper uid_wrapper nmap-ncat mariadb mongodb" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Allow cron as user
RUN chmod 777 /var/spool/cron/ /var/run/ && \
    chmod u-s /usr/bin/crontab /bin/crontab && \
    chmod u+s /usr/sbin/crond /lib64/libnss_wrapper.so* /lib64/libuid_wrapper.so* && \
    sed -i -s 's/^\(account\s\+include\s\+password-auth\)$/#\1/' /etc/pam.d/crond && \
    echo -e 'user\ndefault' > /etc/cron.allow && rm -f /etc/cron.deny && \
    mkdir -p /etc/cron/{minutely,hourly,daily,weekly,monthly} && \
    chmod -R g+rw /etc && \
    chmod -R 777 /var/log

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

RUN chown -R 1001:0 /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
