# uml-alpine

Boot **Alpine Linux inside User Mode Linux (UML)** — the Linux kernel compiled as a
plain userspace ELF executable — entirely within a GitHub Actions job, with working
guest networking.

[![uml-alpine](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml/badge.svg)](https://github.com/ZeynepMakarov98/uml-alpine/actions/workflows/uml-alpine.yml)

## What the [workflow](.github/workflows/uml-alpine.yml) does

1. Resolves the latest **6.12 LTS** kernel from `kernel.org/releases.json` (6.12 keeps
   the classic UML network transports used here) and builds it (`make ARCH=um`) with the
   Alpine minirootfs embedded as initramfs.
2. Brings up a host-side `tap0`/NAT bridge for the guest (`10.0.2.15` ⇄ `10.0.2.1`).
3. Boots the kernel as a normal process with a TUN/TAP NIC
   (`eth0=tuntap,tap0,... con0=fd:0,fd:1`), **SMP** (`ncpus=$(nproc)`), and **randomized
   guest RAM** in the 3.0–3.5 GiB range on a 64 MiB grid — no hypervisor involved.
4. Runs a custom command **inside the Alpine guest** for a bounded time, verifies it
   exited successfully, then powers the guest down cleanly.

## Run it with your own command

Trigger via **Actions → uml-alpine → Run workflow** (or on `push` to `main`). Inputs:

- `cmd` — shell command to run inside the guest (default: fetch `http://example.com`
  over the network and print the byte count).
- `timeout_sec` — kill the command after this many seconds (default: `30`).

Guest transcript (from the Actions log, default command):

```
=== ALPINE BOOTED INSIDE UML (tap network) ===
3.24.0
--- eth0 ---
eth0      Link encap:Ethernet  HWaddr DE:AD:BE:EF:00:01  
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
--- route ---
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.2.1        0.0.0.0         UG    0      0        0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0
--- running custom cmd (time limit 30s): wget -q -O - http://example.com > /tmp/example.html && echo NETWORK-OK: got $(wc -c < /tmp/example.html) bytes from example.com ---
NETWORK-OK: got 577 bytes from example.com
--- cmd exit code: 0 ---
=== UML-ALPINE-TEST-PASSED ===
reboot: Power down
``` 

The Linux kernel itself runs as an ordinary ELF process on the runner, with real Alpine
userspace (busybox + apk, wget, etc.) executing inside it and reaching the internet via
the host tap/NAT.
