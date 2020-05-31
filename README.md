# 💾 [y2k.lol](https://y2k.lol/)

Nostalgic time machine powered by on-demand Windows Me VMs and [my first website](https://jarv.is/y2k/). Inspired by [charlie.bz](https://charlie.bz/) (and quarantine boredom).

The backend isn't quite ready to be open-sourced (read: it's still a fatally embarrassing ball of spaghetti) but will be moved here very soon! 🍝

<p align="center"><a href="https://y2k.lol/"><img width="600" src="screenshot.png"></a></p>

## Requirements

- [QEMU 4.x](https://www.qemu.org/) (target i386)
- [websocketd](https://github.com/joewalnes/websocketd)
- [noVNC](https://github.com/novnc/noVNC)
- [Cloudflare Workers](https://workers.cloudflare.com/) & [Argo Tunnel](https://www.cloudflare.com/products/argo-tunnel/)
- [Microsoft Bob](https://en.wikipedia.org/wiki/Microsoft_Bob)

## To-Do

- [x] Sync user's mouse cursor/movements with VM
- [ ] Error messages: no websockets, server down, etc.
- [ ] Usage limits
- [ ] Responsive browser sizing
- [ ] **Commit backend scripts**

## License

This project is distributed under the [MIT license](LICENSE.md).
