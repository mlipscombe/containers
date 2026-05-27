#!/bin/sh

set -eu

mkdir -p /config

node - <<'EOF' > /config/runtime-config.js
const config = {
  googleClientId: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID || "",
  wsUrl: process.env.NEXT_PUBLIC_WS_URL || "",
};

process.stdout.write(
  "window.__MULTICA_RUNTIME_CONFIG__ = Object.freeze(" +
    JSON.stringify(config) +
    ");\n",
);
EOF

exec node apps/web/server.js
