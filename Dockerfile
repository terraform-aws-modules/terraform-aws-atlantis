ARG CODE_VERSION=v0.15.0
FROM runatlantis/atlantis:${CODE_VERSION}

RUN apk add --no-cache \
        python3 \
        python3-dev \
        py3-pip \
        gcc \
        linux-headers \
        musl-dev \
    && python3 -m pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install --extra-index-url https://pip-readonly-1:eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiJYaFp6N3l3eV8zSGdEdDFFa3BNTTY4bnYzTGNRd0syb1p6SFI0TjY3cXdnIn0.eyJzdWIiOiJqZnJ0QDAxYnQzbnhtNTltNGVoMGd4NHBwZjcxZzBxXC91c2Vyc1wvcGlwLXJlYWRvbmx5LTEiLCJzY3AiOiJtZW1iZXItb2YtZ3JvdXBzOnByaXZhdGUtcmVhZGVycyBhcGk6KiIsImF1ZCI6ImpmcnRAMDFidDNueG01OW00ZWgwZ3g0cHBmNzFnMHEiLCJpc3MiOiJqZnJ0QDAxYnQzbnhtNTltNGVoMGd4NHBwZjcxZzBxXC91c2Vyc1wvc2tvbmFrb3YiLCJpYXQiOjE1NzcyMDk0OTEsImp0aSI6ImQ0OTAyNzhjLWMwYzUtNGZlNS1iNGY1LWM3ZTBlMmU1Yzk1MSJ9.jixAYrXCq-Qg1gucbr_4ve2H2gtEoPpKc28cs4ZWlaMZdGhAbSZ1Qm19Lu5rdBCZc0yvRufUdAk6mp4Xu9Aszp70eUC-6ZqqnaD8UNGNZow-aGJ_uy_2NUyTVChXIn9XWSnSPO8rx1R6HelQ1ojVNW84GZSeEQ98mlYL17KBPSSuFRErnKVLERfpIymO0243WHW_9YLfsCpoD3qrBGoXvcrWUg4mMu4LCoRnm1vTsNlog5GEtFN0tsxuI4G909h6lr5F4vBKeGRYvTJk5HURAQDTkbvEt86SdmNay_ip8P9y_xvvpkxnKcMJVIPzu5BTGG7fFHRQAx6ISpHlkXwTsQ@thm.jfrog.io/thm/api/pypi/th-pip-prod/simple service-infrastructure
COPY --chown=root:atlantis tasks.py /home/atlantis/

ARG SECRET_KEY_FILE
COPY --chown=root:atlantis ${SECRET_KEY_FILE} /home/atlantis/atlantis-app-key.pem
RUN chmod 644 /home/atlantis/atlantis-app-key.pem
