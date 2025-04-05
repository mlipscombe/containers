ARG VERSION
FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apt update \
    && apt install -y --no-install-recommends python3-pip python3-venv python3-dev git

USER root
WORKDIR /app

RUN git clone https://github.com/exo-explore/exo.git /app && cd /app && git checkout "${VERSION}"

RUN python3 -m venv /app
ENV PATH="/app/bin:$PATH"

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

RUN pip install --no-cache-dir .

FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04 AS target

RUN apt update \
    && apt install -y --no-install-recommends libgl1 libglib2.0-dev uuid-runtime catatonit

# Copy exo build to target image
COPY --from=builder /app /app

RUN apt autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./apps/exo/entrypoint.sh /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/exo-explore/exo"
