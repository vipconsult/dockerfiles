FROM golang

#WORKDIR /go/src/portalBackend
WORKDIR /
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	ssmtp
RUN sed -i "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf

RUN go get github.com/lib/pq

#CMD    ["go", "run", "main.go", "jobs.go", "mail.go","webHosting.go"]

ADD		setup.sh /setup.sh

ENTRYPOINT      ["/setup.sh"]
