FROM FROM docker:17.03-rc
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>


RUN apk --update add openjdk8-jre \
    && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.3/swarm-client-3.3.jar
CMD ["java -jar path/to/swarm-client.jar -master http://10.0.0.101 -password admin -username admin"]
