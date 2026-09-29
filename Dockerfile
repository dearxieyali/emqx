FROM ubuntu:20.04@sha256:f2034e7195f61334e6caff6ecf2e965f92d11e888309065da85ff50c617732b8

ARG PROFILE=emqx

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates procps \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system --gid 1000 emqx \
    && useradd --system --create-home --uid 1000 --gid emqx emqx

COPY --chown=emqx:emqx _build/${PROFILE}/rel/emqx /opt/emqx
COPY --chmod=755 deploy/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN ln -s /opt/emqx/bin/* /usr/local/bin/ \
    && chgrp -R emqx /opt/emqx \
    && chmod -R g+w /opt/emqx

WORKDIR /opt/emqx

USER emqx

VOLUME ["/opt/emqx/log", "/opt/emqx/data"]

EXPOSE 1883 8083 8084 8883 18083 4370 5369

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/opt/emqx/bin/emqx", "foreground"]
