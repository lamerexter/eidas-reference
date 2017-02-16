FROM ubuntu:trusty
MAINTAINER suneet.kamath@digital.cabinet-office.gov.uk

RUN echo "deb [arch=amd64 ] http://gb.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list.d/ubuntu.list
RUN echo "deb [arch=amd64 ] http://gb.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse" > /etc/apt/sources.list.d/ubuntu-security.list
RUN echo "deb [arch=amd64 ] http://gb.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse" > /etc/apt/sources.list.d/ubuntu-updates.list
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN echo "deb [arch=amd64 ] https://packages.ida.digital.cabinet-office.gov.uk/ main main" > /etc/apt/sources.list.d/ida-aptly_main.list
RUN apt-get update
RUN apt-get install --force-yes -y oracle-java8-jre
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-8-oracle-x64" >> ~/.bashrc

ENV JAVA_VERSION_MAJOR=8
RUN curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
        http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/jre-8-oracle-x64/lib/security/;

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Reference : https://github.com/docker-library/tomcat/blob/master/8.5/jre8/Dockerfile
#
# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "update.sh" (https://github.com/docker-library/tomcat/blob/master/update.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
RUN set -ex; \
for key in $GPG_KEYS; do \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.11
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
 && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
 && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
 && gpg --verify tomcat.tar.gz.asc \
 && tar -xvf tomcat.tar.gz --strip-components=1 \
 && rm bin/*.bat \
 && rm tomcat.tar.gz*

EXPOSE 8080
# CMD ["catalina.sh", "jpda run"]

ENV JPDA_ADDRESS 8000
ENV JPDA_TRANSPORT dt_socket
EXPOSE 8000
CMD ["catalina.sh", "jpda", "run"]
