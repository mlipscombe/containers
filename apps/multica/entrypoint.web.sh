#!/bin/sh

set -eu

mkdir -p /config

node - <<'EOF'
const fs = require("fs");

const remoteApiUrl =
  (process.env.REMOTE_API_URL || process.env.NEXT_PUBLIC_API_URL || "").trim();

if (remoteApiUrl) {
  const manifestPath = "/app/apps/web/.next/routes-manifest.json";
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const backendRoutes = new Map([
    ["/api/:path*", "/api/:path*"],
    ["/ws", "/ws"],
    ["/auth/:path*", "/auth/:path*"],
    ["/uploads/:path*", "/uploads/:path*"],
  ]);

  for (const rewrite of manifest.rewrites?.afterFiles || []) {
    const destinationPath = backendRoutes.get(rewrite.source);
    if (destinationPath) {
      rewrite.destination = `${remoteApiUrl}${destinationPath}`;
    }
  }

  fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
}
EOF

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
