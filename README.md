# uml-alpine

Booting **Alpine Linux inside User Mode Linux (UML)** — the Linux kernel compiled
as a plain userspace ELF executable — entirely within a GitHub Actions job.

[![uml-alpine](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml/badge.svg)](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml)

What the [workflow](.github/workflows/uml-alpine.yml) does:

1. Resolves the latest stable kernel from `kernel.org/releases.json`
2. Builds a UML kernel (`make ARCH=um`) with the Alpine minirootfs embedded as initramfs
3. Boots it as a normal process: `./linux mem=256M con0=fd:0,fd:1`
4. Runs `echo hello` and friends **inside the Alpine guest** (via its `/init` on the
   UML console), verifies the output, then powers the guest down cleanly

Guest transcript (from the Actions log):

```
=== ALPINE BOOTED INSIDE UML ===
3.24.0
--- running: echo hello ---
hello
--- running: cat /etc/alpine-release ---
3.24.0
--- running: uname -r ---
7.3.4
--- running: apk --version ---
apk-tools 3.0.6-r0, compiled for x86_64.
=== UML-ALPINE-TEST-PASSED ===
reboot: Power down
```

No hypervisor involved — the Linux kernel itself runs as an ordinary ELF process
on the runner, with real Alpine userspace (busybox + apk) executing inside it.

Re-run anytime via **Actions → uml-alpine → Run workflow**.
