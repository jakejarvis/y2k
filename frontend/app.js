import RFB from "@novnc/novnc/core/rfb.js";

// DOS-style box for text
const cmd = document.getElementById("cmd-text");

if (window.WebSocket) {
  // https://github.com/novnc/noVNC/blob/master/docs/API.md
  const rfb = new RFB(
    document.getElementById("display"),
    "wss://y2k.pipe.fail",
    {
      wsProtocols: ["binary", "base64"]
    }
  );
  rfb.addEventListener("connect", () => {
    console.log("successfully connected to VM socket!");
  });
  rfb.addEventListener("disconnect", (detail) => {
    console.warn("VM ended session remotely:", detail);
  });

  // give up after 15 seconds (this also is rendered behind the VNC display in case it crashes and goes poof)
  setTimeout(() => {
    cmd.textContent = "Oh dear, it looks like something went very wrong. :(\n\nRefresh or try again in a bit.\n\n\nPress the Any key to continue.";
  }, 15000);
} else {
  // browser doesn't support websockets
  cmd.textContent = "WebSockets must be enabled to play in the Y2K Sandbox!!!\n\nPress the Any key to continue.";
}
