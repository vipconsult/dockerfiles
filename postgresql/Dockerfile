FROM postgres:9.3

# set the locale to uk
RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    sed -i -e "s/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/g" /etc/locale.gen && \
    locale-gen
# change the folder owner UID to postgres

#RUN usermod -u  $(stat -c "%u" /home/postgres/) postgres
