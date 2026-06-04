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
  const seen = new Set();

  const rewriteGroups = Array.isArray(manifest.rewrites)
    ? { all: manifest.rewrites }
    : manifest.rewrites || {};

  for (const rewrites of Object.values(rewriteGroups)) {
    if (!Array.isArray(rewrites)) continue;

    for (const rewrite of rewrites) {
      const destinationPath = backendRoutes.get(rewrite.source);
      if (destinationPath) {
        rewrite.destination = `${remoteApiUrl}${destinationPath}`;
        seen.add(rewrite.source);
      }
    }
  }

  const missing = [...backendRoutes.keys()].filter((source) => !seen.has(source));
  if (missing.length > 0) {
    throw new Error(
      `Unable to apply REMOTE_API_URL: missing expected rewrite(s): ${missing.join(", ")}`,
    );
  }

  fs.writeFileSync(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
}
EOF

exec node apps/web/server.js
