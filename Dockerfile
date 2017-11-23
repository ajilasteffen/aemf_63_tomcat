FROM ubuntu:14.04

# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies & essentials
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 8 (& re-install certificats)
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install --reinstall ca-certificates && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Set JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Create folders & set rights
RUN mkdir /opt/aem/
RUN mkdir /opt/aem/crx/
RUN mkdir /opt/aem/keystore/
RUN chmod 777 /opt/aem/crx

# Install pre-configured Tomcat
# ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21542&authkey=AGUCj-5xxM5BT3E /opt/tomcat.zip
# RUN unzip /opt/tomcat.zip -d /opt/
# RUN rm /opt/tomcat.zip

# Install pre-configured Tomcat (debug mode)
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21547&authkey=AHGPEUnwMT-o70M /opt/tomcat-debug.zip
RUN unzip /opt/tomcat-debug.zip -d /opt/
RUN rm /opt/tomcat-debug.zip

# Add AIS keystore
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21534&authkey=AAJNkrsXdoyy000 /opt/aem/keystore/ajila-swisscom-ais-ssl.jks

# Install AEM
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21544&authkey=APl01iAYTh5Vadk /opt/tomcat/webapps/ROOT.war

# Add AEM license file
ADD https://onedrive.live.com/download?cid=ABC9EC3E389595EB&resid=ABC9EC3E389595EB%21535&authkey=ABIw0ytIYlDWX-M /opt/aem/license.properties

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8888
EXPOSE 8009
VOLUME "/opt/aem"
WORKDIR /opt/aem

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
