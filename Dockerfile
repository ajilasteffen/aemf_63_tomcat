FROM ubuntu:16.04

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Fix shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install updates, dependencies & essentials
RUN apt-get update && \
apt-get install -y locales && \ 
apt-get dist-upgrade -y && \ 
apt-get install unzip && \
apt-get install -y git build-essential curl wget software-properties-common

# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Remove any existing JDKs
RUN apt-get --purge remove openjdk*

# Install Oracle JDK 8 (& re-install certificats)
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
apt-get install --reinstall ca-certificates && \
apt-get install -y --no-install-recommends --allow-unauthenticated oracle-java8-installer && \
apt-get clean all

# Create folders & set rights
RUN mkdir /opt/aem/
RUN mkdir /opt/aem/crx/
RUN mkdir /opt/aem/keystore/
RUN chmod -R 777 /opt/aem/crx

# Install pre-configured Tomcat
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21542&authkey=AGUCj-5xxM5BT3E /opt/tomcat.zip
RUN unzip /opt/tomcat.zip -d /opt/
RUN rm /opt/tomcat.zip

# Install pre-configured Tomcat (debug mode)
# ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21547&authkey=AHGPEUnwMT-o70M /opt/tomcat-debug.zip
# RUN unzip /opt/tomcat-debug.zip -d /opt/
# RUN rm /opt/tomcat-debug.zip

# Add AIS keystore
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21534&authkey=AAJNkrsXdoyy000 /opt/aem/keystore/ajila-swisscom-ais-ssl.jks

# Install AEM
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21553&authkey=AGBLDvT7RZRM2QY /opt/tomcat/webapps/ROOT.war

# Add AEM license file
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21535&authkey=ABIw0ytIYlDWX-M /opt/aem/license.properties

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin


EXPOSE 8080
# EXPOSE 8888
EXPOSE 8009
# VOLUME "/opt/aem"
WORKDIR /opt/aem

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
