# syntax=docker/dockerfile:1

# Preserve Moodle's extensions and entrypoint while upstream images catch up
# with the PHP security release. Patch releases share the PHP extension ABI.
FROM moodlehq/moodle-php-apache:8.4@sha256:3e910075c08dc73c8e18732f5e80c8fb9a60ae72eaf52b1ee198bb510e4fd9d6 AS moodle

FROM moodle AS builder
ARG VERSION=8.4.27
ARG PHP_SOURCE_SHA256=dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0

RUN set -eux; \
    php -r '$extensions = get_loaded_extensions(); sort($extensions); file_put_contents("/tmp/extensions.json", json_encode($extensions));'; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        $PHPIZE_DEPS apache2-dev libargon2-dev libcurl4-openssl-dev \
        libonig-dev libreadline-dev libsodium-dev libsqlite3-dev \
        libssl-dev libxml2-dev zlib1g-dev; \
    curl -fsSL "https://www.php.net/distributions/php-${VERSION}.tar.xz" -o /tmp/php.tar.xz; \
    echo "${PHP_SOURCE_SHA256}  /tmp/php.tar.xz" | sha256sum -c -; \
    mkdir -p /usr/src/patched-php; \
    tar -xJf /tmp/php.tar.xz -C /usr/src/patched-php --strip-components=1; \
    cd /usr/src/patched-php; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
        PHP_BUILD_PROVIDER='https://github.com/mlipscombe/containers' PHP_UNAME='Linux - Docker'; \
    ./configure \
        --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --sysconfdir=/usr/local/etc \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --enable-option-checking=fatal --with-mhash --with-pic \
        --enable-mbstring --enable-mysqlnd --with-password-argon2 \
        --with-sodium=shared --with-pdo-sqlite=/usr --with-sqlite3=/usr \
        --with-curl --with-iconv --with-openssl --with-readline --with-zlib \
        --disable-phpdbg --with-pear \
        --with-libdir="lib/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
        --disable-cgi --with-apxs2; \
    make -j "$(nproc)"; \
    make install; \
    strip --strip-all /usr/local/bin/php /usr/lib/apache2/modules/libphp.so; \
    php -r '$extensions = get_loaded_extensions(); sort($extensions); if (json_encode($extensions) !== file_get_contents("/tmp/extensions.json")) { fwrite(STDERR, "PHP extensions changed during upgrade\n"); exit(1); }'; \
    test "$(php -r 'echo PHP_VERSION;')" = "$VERSION"; \
    cp /tmp/php.tar.xz /usr/src/php.tar.xz

FROM moodle AS image
ARG VERSION=8.4.27
ARG PHP_SOURCE_SHA256=dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0
ENV PHP_VERSION=${VERSION} \
    PHP_URL=https://www.php.net/distributions/php-${VERSION}.tar.xz \
    PHP_ASC_URL=https://www.php.net/distributions/php-${VERSION}.tar.xz.asc \
    PHP_SHA256=${PHP_SOURCE_SHA256}
COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /usr/lib/apache2/modules/libphp.so /usr/lib/apache2/modules/libphp.so
COPY --from=builder /usr/src/php.tar.xz /usr/src/php.tar.xz
RUN test "$(php -r 'echo PHP_VERSION;')" = "$PHP_VERSION" \
    && php -r 'exit(PHP_VERSION_ID >= 80427 && PHP_VERSION_ID < 80500 ? 0 : 1);' \
    && APACHE_DOCUMENT_ROOT=/var/www/html apache2ctl -t
