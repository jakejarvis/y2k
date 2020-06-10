# 💾 [Y2K Land](https://y2k.land/) [![Uptime Robot status](https://img.shields.io/uptimerobot/status/m785127956-49458d510e68142930db872d?logo=windows%2095)](https://y2k.land/) [![Uptime Robot ratio (7 days)](https://img.shields.io/uptimerobot/ratio/7/m785127956-49458d510e68142930db872d?color=%23638ebd&logo=zeit)](https://status.jrvs.io/785127956) [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jakejarvis/y2k/Deploy?color=orange&logo=github)](https://github.com/jakejarvis/y2k/actions?query=workflow%3ADeploy)

Nostalgic time machine powered by on-demand Windows Me® VMs, [my first website](https://jarv.is/y2k/), and quarantine boredom. 📟

[**📝 Read the blog post here.**](https://jarv.is/notes/y2k-land/)

<p align="center"><a href="https://y2k.land/"><img width="600" src="screenshot.png"></a></p>

## Requirements

- Docker
- [QEMU](https://www.qemu.org/) (target i386)
- [websocketd](https://github.com/joewalnes/websocketd)
- [noVNC](https://github.com/novnc/noVNC)
- [Cloudflare Workers](https://workers.cloudflare.com/) & [Argo Tunnel](https://www.cloudflare.com/products/argo-tunnel/)
- [Microsoft Bob](https://en.wikipedia.org/wiki/Microsoft_Bob)

## Inspired By

- [charlie.bz](https://charlie.bz/)
- [benjojo.co.uk](https://benjojo.co.uk/)
- [Microsoft Bob](https://en.wikipedia.org/wiki/Microsoft_Bob)

## To-Do

- [x] **Commit backend scripts**
- [x] Sync user's mouse cursor/movements with VM
- [x] Error messages: no websockets, server down, etc.
- [ ] Usage limits
- [ ] Responsive browser sizing

## License

This project is distributed under the [MIT license](LICENSE.md).
