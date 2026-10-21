# Moodle PHP security image

This image replaces PHP 8.4.26 in the pinned upstream Moodle image with PHP
8.4.27, fixing CVE-2026-109618 and CVE-2026-109619. Both the CLI executable and
Apache's `libphp.so` are rebuilt. Existing Moodle extensions, PHP configuration,
entrypoint hooks, locales, and document-root handling are preserved. The build
checks that the complete enabled extension list remains unchanged.

The PHP source archive is verified against the SHA-256 published by PHP:
https://www.php.net/releases/index.php?json&version=8.4.27

Update `VERSION` and `PHP_SOURCE_SHA256` together in `docker-bake.hcl` for later
PHP 8.4 releases. Keep upgrades within PHP 8.4 while reusing upstream extension
binaries; a new PHP minor version requires rebuilding those extensions too.
Switch back to the upstream Moodle image once it ships a patched PHP runtime.
