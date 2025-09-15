ARG BUILD_FROM
FROM $BUILD_FROM AS RUNNING

RUN apk update && \
    apk add --no-cache \
		'rsync=3.4.0-r0' \
		'coreutils=9.3-r2'

COPY root /
RUN chmod a+x /run.sh
ENTRYPOINT [ "/run.sh" ]

