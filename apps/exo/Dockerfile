ARG VERSION
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apt update \
    && apt install -y --no-install-recommends python3-pip python3-venv python3-dev git libgl1-mesa-dev libdrm-dev

USER root
WORKDIR /app

RUN git clone https://github.com/exo-explore/exo.git /app && cd /app && git checkout "${VERSION}"

RUN python3 -m venv /app
ENV PATH="/app/bin:$PATH"

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

RUN pip install --no-cache-dir .

RUN pip install torch --index-url https://download.pytorch.org/whl/cu126

FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 AS target

RUN apt update \
    && apt install -y --no-install-recommends libgl1 libglib2.0-dev uuid-runtime catatonit

# Copy exo build to target image
COPY --from=builder /app /app

RUN apt autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./apps/exo/entrypoint.sh /entrypoint.sh

WORKDIR /app
VOLUME ["/data"]

ENV EXO_DATA="/data"
ENV EXO_LISTEN_PORT="5000"
ENV EXO_NODE_PORT="5001"
ENV EXO_BROADCAST_PORT="5002"

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/exo-explore/exo"
