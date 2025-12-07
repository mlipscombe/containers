# syntax=docker/dockerfile:1

ARG RUBY=3.4
ARG VERSION

FROM instructure/ruby-passenger:$RUBY-jammy
LABEL maintainer="Instructure"

ARG RUBY
ARG VERSION
ARG POSTGRES_CLIENT=14
ENV APP_HOME=/usr/src/app/
ENV RAILS_ENV=production
ENV SASS_STYLE=compressed
ENV RAILS_LOAD_ALL_LOCALES=1
ENV NGINX_MAX_UPLOAD_SIZE=10g
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ARG CANVAS_RAILS=8.0
ENV CANVAS_RAILS=${CANVAS_RAILS}

ENV CANVAS_LMS_STATS_COLLECTION=opt_out

ENV NODE_MAJOR=20
ENV GEM_HOME=/home/docker/.gem/$RUBY
ENV PATH=${APP_HOME}bin:$GEM_HOME/bin:$PATH
ENV BUNDLE_APP_CONFIG=/home/docker/.bundle

WORKDIR $APP_HOME

USER root
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && printf 'path-exclude /usr/share/doc/*\npath-exclude /usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && add-apt-repository ppa:git-core/ppa -ny \
    && apt-get update -qq \
    && apt-get install -qqy --no-install-recommends \
    nodejs \
    libxmlsec1-dev \
    python3-lxml \
    python-is-python3 \
    libicu-dev \
    libidn11-dev \
    parallel \
    postgresql-client-$POSTGRES_CLIENT \
    tzdata \
    unzip \
    pbzip2 \
    \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /home/docker/.gem/ruby/$RUBY_MAJOR.0

RUN gem install bundler --no-document -v 2.5.10 \
    && find $GEM_HOME ! -user docker | xargs chown docker:docker
RUN npm install -g npm@9.8.1 && npm cache clean --force

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable && corepack prepare yarn@1.19.1 --activate

# Download and extract Canvas LMS release
RUN mkdir -p $APP_HOME \
    && if echo "${VERSION}" | grep -q "^prod\|^stable$"; then \
    DOWNLOAD_URL="https://github.com/instructure/canvas-lms/archive/refs/heads/${VERSION}.tar.gz"; \
    else \
    DOWNLOAD_URL="https://github.com/instructure/canvas-lms/archive/refs/tags/release/${VERSION}.tar.gz"; \
    fi \
    && curl -fsSL "${DOWNLOAD_URL}" \
    | tar xzf - -C $APP_HOME --strip-components=1 \
    && chown -R docker:docker $APP_HOME

COPY . /
RUN chmod +x /entrypoint.sh

USER docker

RUN mkdir -p tmp/files
ENV COMPILE_ASSETS_BRAND_CONFIGS=0
ENV COMPILE_ASSETS_NPM_INSTALL=0
RUN unset RUBY && bundle config --global build.nokogiri --use-system-libraries && \
    bundle config --global build.ffi --enable-system-libffi && \
    bundle install
RUN yarn install --frozen-lockfile || yarn install --frozen-lockfile --network-concurrency 1 && \
    bin/rails canvas:compile_assets --trace && \
    rm -rf node_modules

RUN cp /defaults/* /usr/src/app/config/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/tini" "--" "/entrypoint.sh"]
