# syntax=docker/dockerfile:1

ARG VERSION
FROM quay.io/jupyter/all-spark-notebook:${VERSION}

ENV JUPYTER_ENABLE_LAB=yes
USER root

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
  bash ~/.bash_it/install.sh --silent

RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=18 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends nodejs texlive-latex-extra texlive-xetex \
        ca-certificates build-essential \
        postgresql-client libpq-dev wget curl vim raptor2-utils && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g bash-language-server dockerfile-language-server-nodejs \
    pyright sql-language-server typescript-language-server \
    unified-language-server vscode-css-languageserver-bin \
    vscode-html-languageserver-bin vscode-json-languageserver-bin \
    yaml-language-server

USER $NB_UID

RUN python -m pip install --upgrade pip

COPY ./defaults/requirements.txt /
RUN pip install --upgrade -r /requirements.txt

COPY ./defaults/config/ /home/$NB_USER/.jupyter/
