FROM python:3.12-bookworm

ARG CALIBRE_VERSION

ENV CALIBRE_APP_DB_PATH=/data/app.db

# Library path.
ENV CALIBRE_LIBRARY_PATH=/books
ENV _CALIBRE_CONFIG_CALIBRE_DIR=$CALIBRE_LIBRARY_PATH

# Admin user, set by entrypoint
ENV CALIBRE_ADMIN_USERNAME=admin
ENV CALIBRE_ADMIN_PASSWORD=Admin123!

# Logs to stdout. _CALIBRE environment variables updates sqlite
# database via entrypoint
ENV CALIBRE_LOG_PATH=/proc/self/fd/1
ENV _CALIBRE_CONFIG_ACCESS_LOG=1
ENV _CALIBRE_CONFIG_ACCESS_LOGFILE=/proc/self/fd/1

ENV _CALIBRE_CONFIG_CONVERTERPATH=/bin/ebook-convert

RUN pip install calibreweb==$CALIBRE_VERSION
# Patch calibre-web to allow auto creation of users via headers auth
# https://github.com/janeczku/calibre-web/pull/2899
RUN curl -s -L https://patch-diff.githubusercontent.com/raw/janeczku/calibre-web/pull/2899.patch \
    | patch -p1 -t -d /usr/local/lib/python3.12/site-packages/calibreweb || exit 0

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends calibre sqlite3 less

RUN adduser -u 1000 --home /data calibre-web

# Library volume
RUN mkdir /books && chown calibre-web:calibre-web /books
VOLUME /books

USER calibre-web
WORKDIR /data

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD exec cps -p $CALIBRE_APP_DB_PATH -o $CALIBRE_LOG_PATH
