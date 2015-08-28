FROM golang

EXPOSE 55555
WORKDIR /go/src/portalBackend
RUN go get github.com/lib/pq

CMD    ["go", "run", "main.go", "jobs.go", "mail.go","webHosting.go"]

