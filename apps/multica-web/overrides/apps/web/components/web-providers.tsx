"use client";

import { Suspense } from "react";
import { CoreProvider } from "@multica/core/platform";
import { deriveWsUrl, getRuntimeConfig } from "@/lib/runtime-config";
import { WebNavigationProvider } from "@/platform/navigation";
import {
  setLoggedInCookie,
  clearLoggedInCookie,
} from "@/features/auth/auth-cookie";
import { PageviewTracker } from "./pageview-tracker";

// Legacy token in localStorage → keep this session in token mode so users who
// logged in before the cookie-auth migration stay authed. They migrate to
// cookie mode on their next logout/login cycle (logout clears multica_token).
// Sunset: once telemetry shows <1% of sessions still carry multica_token,
// delete this branch and hard-code `cookieAuth` — the localStorage token is
// XSS-exposed and is the exact thing the cookie migration exists to remove.
function hasLegacyToken(): boolean {
  if (typeof window === "undefined") return false;
  try {
    return Boolean(window.localStorage.getItem("multica_token"));
  } catch {
    return false;
  }
}

export function WebProviders({ children }: { children: React.ReactNode }) {
  const cookieAuth = !hasLegacyToken();
  const runtimeConfig = getRuntimeConfig();

  return (
    <CoreProvider
      apiBaseUrl={runtimeConfig.apiBaseUrl}
      wsUrl={deriveWsUrl(runtimeConfig.wsUrl)}
      cookieAuth={cookieAuth}
      onLogin={setLoggedInCookie}
      onLogout={clearLoggedInCookie}
    >
      {/* Suspense boundary is required by Next.js for useSearchParams in
          a client component mounted this high in the tree. */}
      <Suspense fallback={null}>
        <PageviewTracker />
      </Suspense>
      <WebNavigationProvider>{children}</WebNavigationProvider>
    </CoreProvider>
  );
}
