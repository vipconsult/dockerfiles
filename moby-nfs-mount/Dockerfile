FROM alpine
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

# we need nsenter to enter the docker host and mount a global nfs mount so all ocntainers can use it for persistant data
# install nsenter so we can enter the docker host - this is the only way with the current moby linux
RUN apk update && apk add util-linux
ADD start.sh /start.sh
RUN chmod o+x /start.sh

CMD ["/start.sh"]
