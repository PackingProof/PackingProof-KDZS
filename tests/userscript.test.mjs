import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const manifest = JSON.parse(await readFile(new URL("../manifest.json", import.meta.url), "utf8"));
const script = await readFile(new URL("../payload/PackingProof-Order-Integration-KDZS.user.js", import.meta.url), "utf8");

test("keeps the two-part source version and PackingProof placeholders", () => {
  const version = script.match(/^\/\/\s*@version\s+([^\r\n]+)/m)?.[1].trim();
  assert.equal(version, "2.14");
  assert.equal(manifest.version, version);
  assert.match(version, /^\d+\.\d+$/);
  assert.match(script, /\/\/ PACKING_PROOF_CONNECT_TARGETS/);
  assert.match(script, /\/\/ PACKING_PROOF_UPDATE_URLS/);
  assert.match(script, /const PACKING_PROOF_RECORDERS = \[\]/);
  assert.match(script, /const PACKING_PROOF_HOST = null/);
  assert.doesNotMatch(script, /^\/\/\s*@updateURL/m);
  assert.doesNotMatch(script, /^\/\/\s*@downloadURL/m);
  assert.doesNotMatch(script, /^\/\/\s*@connect\s+\*/m);
});

test("uses signed extension tasks with the legacy fallback", () => {
  for (const expected of [
    "packingproof-extension-request-v1",
    "/api/extensions/v1/enroll",
    "/api/extensions/v1/scan-tasks/next?waitSeconds=20",
    "/api/extensions/v1/scan-results",
    "if (!await startExtensionTaskPolling()) startOrderLookupPolling()",
    ".finally(() => startOrderLookupPolling())",
    "GM_setValue(EXTENSION_CREDENTIAL_KEY, state)",
  ]) assert.match(script, new RegExp(escapeRegExp(expected)));
  assert.doesNotMatch(script, /const EXTENSION_CREDENTIAL =/);
});

test("broadcasts independently and keeps refund work isolated", () => {
  for (const expected of [
    "const IS_REFUND_WORKER",
    "claimRefundWorkerLease()",
    "maintainRefundWorker(monitorReachable)",
    "queryRequestedRefundSnapshot(pending.trackingNumbers || [])",
    "GM_registerMenuCommand('查看订单联动设备'",
    "Promise.allSettled(",
    "getOnlineRecorderEndpoints()",
    "/api/orderinfo/broadcast",
    "sendOrdersThroughHost(orders, devices)",
  ]) assert.match(script, new RegExp(escapeRegExp(expected)));
  assert.doesNotMatch(script, /RTCPeerConnection/);
  assert.doesNotMatch(script, /applyInstalledMonitorAddresses\(\)/);
});

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
