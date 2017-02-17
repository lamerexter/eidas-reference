FROM tomcat:8.5.11-jre8-alpine

ENV JAVA_VERSION_MAJOR=8

RUN apk add --update curl && \
    apk add --update unzip && \
    rm -rf /var/cache/apk/*

#setup Unlimited Strength cryptography for java
RUN curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
        http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/default-jvm/jre/lib/security/;

#CEF recommended tomcat options
ENV CATALINA_OPTS="-XX:MaxPermSize=512m"

## For debugging, the options below need to be uncommented to setup a container for debugging
## The docker-compose file has an example in for proxy-node-1 with the debug port mapped.
## Note: multiple containers will have to have different ports for debug mapped
# ENV JPDA_ADDRESS 8000
# ENV JPDA_TRANSPORT dt_socket
# EXPOSE 8000
# CMD ["catalina.sh", "jpda", "run"]

CMD ["catalina.sh", "run"]
