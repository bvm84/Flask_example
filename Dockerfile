FROM scratch
ADD alpine-minirootfs-3.8.1-x86_64.tar.gz /
ENV RELEASE="v3.8"
ENV MIRROR="http://dl-cdn.alpinelinux.org/alpine"
ENV PACKAGES="alpine-baselayout,busybox,alpine-keys,apk-tools,libc-utils"
ENV TAGS=(alpine:3.8)
ENV PYTHON_VERSION=3.6.6
MAINTAINER Brendel Vadim <brendel.vadim@gmail.com>
# install dependencies
# the lapack package is only in the community repository
# Install dependencies
#https://github.com/docker-library/python/blob/master/3.6/alpine3.7/Dockerfile
# ensure local python is preferred over distribution python
ENV PYTHON_PATH=/usr/lib/python$PYTHON_VERSION \
    PATH="/usr/lib/python$PYTHON_VERSION/bin/:${PATH}"

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# install ca-certificates so that HTTPS works consistently
# the other runtime dependencies for Python are installed later
EXPOSE 5090
WORKDIR /usr/src/app
COPY . .
RUN apk add --no-cache ca-certificates && \
    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
    apk  add --update --no-cache --virtual .build-deps lapack-dev gcc freetype-dev gfortran musl-dev \
    g++ build-base postgresql-dev curl linux-headers pcre-dev python3-dev && \
    apk add uwsgi-python3 python3 && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    #rm -rf public/* && \
    #file="$(ls -1 /usr/src/app)" && echo $file && \
    #curl -O http://projects.unbit.it/downloads/uwsgi-lts.tar.gz && \
    #tar -xvzf uwsgi-lts.tar.gz && \
    #cd uwsgi-lts && \
    #pip3 install uWSGI && \
    pip3 install --upgrade pip && \
    #pip3 install uwsgi-tools &&\
    pip3 install -r requirements.txt && \
    apk del .build-deps \
    # make some useful symlinks that are expected to exist
    && cd /usr/local/bin \
    && ln -s /bin/idle3 idle \
    && ln -s /bin/pydoc3 pydoc \
    && ln -s /bin/python3 python \
    && ln -s /bin/python3-config python-config \
    && addgroup -S uwsgi_group && adduser -S uwsgi_user -G uwsgi_group \
    && chown -v uwsgi_user.uwsgi_group /usr/src/app
USER uwsgi_user
CMD uwsgi uwsgi_init.ini && tail -f /dev/null
#CMD ["service", "uwsgi", "--ini", "/usr/src/app/uwsgi_init.ini"]
#CMD ["sh", "/usr/src/app/start_uwsgi.sh"]

#CMD [ "uwsgi", "--socket", "0.0.0.0:5090", \
#               "--uid", "uwsgi", \
#               "--uid", "uwsgi", \
#               "--plugins", "python3", \
#               "--protocol", "uwsgi", \
#               "--module", "application:app" ]

#CMD ["/usr/src/app/start_uwsgi.sh"]
#CMD [ "uwsgi", "--ini", "/usr/src/app/uwsgi_init.ini" ]
#dummy entry point
#ENTRYPOINT ["tail", "-f", "/dev/null"]
#ENTRYPOINT ["uwsgi", "--ini", "/usr/src/app/uwsgi_init.ini", "tail", "-f", "/dev/null"]
#CMD [ "uwsgi", "--socket", "0.0.0.0:5090", \
#               "--uid", "uwsgi", \
#               "--plugins", "python3", \
#               "--protocol", "uwsgi", \
#               "--module", "application:app" ]
