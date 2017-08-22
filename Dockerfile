############################################################
# Dockerfile to build firefox container images
# Based on armhf-debian
FROM [user.id]/[parent.repository][parent.tag]

###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Install APACHE2 on micro best of my knowledge
USER root
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
#http://security.stackexchange.com/questions/61710/how-to-sandbox-iceweasel-firefox-on-debian
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install git
ENV USER_EMAIL "you@example.com"
ENV USER_NAME "Your Name"
RUN git config --global user.email $USER_EMAIL
RUN git config --global user.name $USER_NAME
RUN apt-get -y install build-essential automake libwxbase3.0-dev libwxgtk3.0-dev libwxgtk-webview3.0-dev
RUN apt-get -y install python-dev
RUN apt-get -y install file gettext
USER developer
RUN mkdir /tmp/Development
WORKDIR /tmp/Development
#wget https://github.com/vslavik/bakefile/releases/download/v0.2.9/bakefile-0.2.9.tar.gz
ADD bakefile-0.2.9.tar.gz /tmp/Development
WORKDIR /tmp/Development/bakefile-0.2.9
USER root
RUN ./configure && make 
RUN make install
USER developer
WORKDIR /tmp/Development
RUN git clone https://github.com/cmaoling/moneymanagerex
WORKDIR /tmp/Development/moneymanagerex
RUN git submodule update --init
RUN mkdir /tmp/Development/moneymanagerex/compile
RUN ./bootstrap.sh
WORKDIR /tmp/Development/moneymanagerex/compile
RUN ../configure && make
USER root
RUN make install
RUN dpkg-reconfigure locales
RUN apt-get -y install gdb
RUN chmod +s /usr/bin/gdb
USER developer
#################### INSTALLATION END #####################
#based on https://github.com/moneymanagerex/moneymanagerex/blob/master/INSTALL.Ubuntu.md
RUN ln -s /tmp/Development/moneymanagerex /home/developer/moneymanagerex
WORKDIR /home/developer
RUN wget ftp://sourceware.org/pub/gdb/releases/gdb-7.5.tar.gz 
RUN tar -xzf /home/developer/gdb-7.5.tar.gz
WORKDIR /home/developer/gdb-7.5
RUN ./configure
RUN make
USER root
RUN make install
