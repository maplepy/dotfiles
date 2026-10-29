// Agent-browser anti-detection init script.
// Runs in the page context before any site JS. Pairs with launch arg
// --disable-blink-features=AutomationControlled (which zeroes navigator.webdriver).
(() => {
  const define = (obj, key, val) => {
    try { Object.defineProperty(obj, key, { get: () => val, configurable: true }); } catch {}
  };

  // navigator.webdriver -> undefined
  Object.defineProperty(navigator, 'webdriver', { get: () => undefined, configurable: true });

  // Realistic navigator properties (defaults on a bare automation box are giveaway)
  define(navigator, 'languages', ['en-US', 'en']);
  define(navigator, 'platform', 'Linux x86_64');
  define(navigator, 'hardwareConcurrency', 8);
  define(navigator, 'deviceMemory', 8);

  // Non-empty navigator.plugins (automation reports 0)
  const plugins = [
    { name: 'Chrome PDF Plugin', description: 'Portable Document Format', filename: 'internal-pdf-viewer' },
    { name: 'Chrome PDF Viewer', description: '', filename: 'mhjfbmdgcfjbbpaeojofohoefgiehjai' },
    { name: 'Native Client', description: '', filename: 'internal-nacl-plugin' },
  ];
  plugins.item = (i) => plugins[i];
  plugins.namedItem = (n) => plugins.find((p) => p.name === n) || null;
  plugins.refresh = () => {};
  Object.defineProperty(navigator, 'plugins', { get: () => plugins, configurable: true });

  // window.chrome (absent under pure automation)
  if (!window.chrome) {
    window.chrome = { runtime: {}, app: { isInstalled: false }, csi: () => {}, loadTimes: () => {} };
  }

  // permissions.query: notifications should resolve to the real Notification state
  const origQuery = navigator.permissions && navigator.permissions.query;
  if (origQuery) {
    navigator.permissions.query = (params) =>
      params.name === 'notifications'
        ? Promise.resolve({ state: Notification.permission })
        : origQuery.call(navigator.permissions, params);
  }

  // WebGL vendor/renderer (automation reports SwiftShader/Google Generic)
  const getParam = WebGLRenderingContext.prototype.getParameter;
  WebGLRenderingContext.prototype.getParameter = function (p) {
    if (p === 37445) return 'Google Inc. (NVIDIA)';
    if (p === 37446) return 'ANGLE (NVIDIA, NVIDIA GeForce GTX 1660 Super Direct3D11 vs_5_0 ps_5_0, D3D11)';
    return getParam.call(this, p);
  };
})();
