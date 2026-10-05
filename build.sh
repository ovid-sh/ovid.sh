#!/bin/sh
# build.sh makes out/, the whole site. Go builds ovid; ovid builds the
# Ovid compiler written in Ovid (ovid's prog/); that compiler builds gen;
# gen renders the pages. Each step prints JSON lines; the first that fails
# stops the build.
set -eu
cd "$(dirname "$0")"
./capture.sh
ovid=.cache/bin/ovid
self=.cache/bin/ovid-self
"$ovid" test
"$ovid" build -C .cache/ovid/prog -o "$PWD/$self"
"$self" build . -o .cache/bin/gen --std .cache/ovid/std | tee captured/gen-build.jsonl
rm -rf out
.cache/bin/gen
