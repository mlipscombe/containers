#!/usr/bin/env bash
set -Eeuo pipefail

APP="${1:?}"
CONFIG="${2:?}"

if yq --exit-status '.schemaVersion' "./apps/${APP}/${CONFIG}" &>/dev/null; then
    gh release download --repo GoogleContainerTools/container-structure-test --pattern "*-linux-$(dpkg --print-architecture)" --output /usr/local/bin/container-structure-test
    chmod +x /usr/local/bin/container-structure-test
else
    gh release download --repo goss-org/goss --pattern "*-linux-$(dpkg --print-architecture)" --output /usr/local/bin/goss
    chmod +x /usr/local/bin/goss
    gh release download --repo goss-org/goss --pattern "dgoss" --output /usr/local/bin/dgoss
    chmod +x /usr/local/bin/dgoss
fi
