# uml-alpine

Booting **Alpine Linux inside User Mode Linux (UML)** — the Linux kernel compiled
as a plain userspace ELF executable — entirely within a GitHub Actions job.

[![uml-alpine](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml/badge.svg)](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml)

What the [workflow](.github/workflows/uml-alpine.yml) does:

1. Resolves the latest stable kernel from `kernel.org/releases.json`
2. Builds a UML kernel (`ARCH=um`) with the Alpine minirootfs embedded as initramfs
3. Boots it as a normal process: `./linux mem=256M con0=fd:0,fd:1`
4. Runs Alpine's `/init` inside the guest (busybox + apk, Alpine 3.24), prints
   `uname -a`, `alpine-release`, apk version, then powers off cleanly

Guest log excerpt:

```
Run /init as init process
=== ALPINE BOOTED INSIDE UML ===
3.24.0
Linux (none) 7.3.4 ... x86_64 Linux
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.24.0
apk-tools 3.0.6-r0, compiled for x86_64.
=== UML-ALPINE-TEST-PASSED ===
reboot: Power down
```

Re-run anytime via **Actions → uml-alpine → Run workflow**.
