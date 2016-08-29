FROM alpine

apk add --no-cache nano
export TERM=xterm
ENV MAJOR 5.0
ENV MINOR 19
ENV FILE lsws-$MAJOR.$MINOR-ent-x86_64-linux.tar.gz
http://www.litespeedtech.com/packages/$MAJOR/$FILE
tar xvfz $FILE
cd lsws-$MAJOR.$MINOR