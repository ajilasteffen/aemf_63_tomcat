FROM ubuntu:14.04


# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Create folders
RUN mkdir /opt/aem/
RUN mkdir /opt/aem/crx/
RUN mkdir /opt/aem/keystore/
RUN chmod 777 /opt/aem/crx

# Install Tomcat
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21540&authkey=ADswZ7eHdERLRYk /opt/tomcat.zip
RUN unzip tomcat.zip -d /opt/
RUN rm tomcat.zip

# Add AIS keystore
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21534&authkey=AAJNkrsXdoyy000 /opt/aem/keystore/ajila-swisscom-ais-ssl.jks

# Install AEM
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21538&authkey=AOdabYPx7chRl94 /opt/tomcat/webapps/ROOT.war

# Add AEM license file
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21535&authkey=ABIw0ytIYlDWX-M /opt/aem/license.properties

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

# Launch Tomcat
# CMD ["/opt/tomcat/bin/catalina.sh", "run"]
