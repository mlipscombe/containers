export interface RuntimeConfig {
  apiBaseUrl?: string;
  googleClientId?: string;
  wsUrl?: string;
}

declare global {
  interface Window {
    __MULTICA_RUNTIME_CONFIG__?: RuntimeConfig;
  }
}

export function getRuntimeConfig(): RuntimeConfig {
  if (typeof window === "undefined") {
    return {};
  }

  return window.__MULTICA_RUNTIME_CONFIG__ ?? {};
}

export function deriveWsUrl(wsUrl?: string): string | undefined {
  if (wsUrl) {
    return wsUrl;
  }

  if (typeof window === "undefined") {
    return undefined;
  }

  const proto = window.location.protocol === "https:" ? "wss:" : "ws:";
  return `${proto}//${window.location.host}/ws`;
}
