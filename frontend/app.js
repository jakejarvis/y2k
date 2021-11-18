import RFB from "https://cdn.skypack.dev/pin/@novnc/novnc@v1.3.0-RRNSIy674lWHJVNg8Apd/mode=imports,min/unoptimized/core/rfb.js";

// DOS-style box for text
const cmd = document.getElementById("cmd-text");

// random tile wallpaper
document.body.style.backgroundImage = "url('tiles/tile_" + Math.floor(20 * Math.random()) + ".jpg')";

if (window.WebSocket) {
  // https://github.com/novnc/noVNC/blob/master/docs/API.md
  const rfb = new RFB(
    document.getElementById("display"),
    "wss://spin-vm.jrvs.io",
    {
      wsProtocols: ["binary", "base64"],
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
    cmd.textContent = "Oh dear, it looks like something went very wrong. :(\n\nTry again in a bit.\n\n\nPress the Any key to continue.";
  }, 15000);
} else {
  // browser doesn't support websockets
  cmd.textContent = "WebSockets must be enabled to play in the Y2K Sandbox!!!\n\nPress the Any key to continue.";
}
