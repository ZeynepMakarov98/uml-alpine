#!/bin/sh
set -e

# Custom command/script that runs inside the UML (Alpine) guest.
# Edit this file to change what executes in the guest.

echo "--- guest run.sh ---"
wget -qO /tmp/example.html http://example.com
echo "got $(wc -c < /tmp/example.html) bytes from example.com"
echo "nproc=$(nproc) processors=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo ?)"
head -c 120 /tmp/example.html
echo
echo "UML-RUN-OK"
