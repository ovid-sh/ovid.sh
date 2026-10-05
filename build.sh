#!/bin/sh
# build.sh makes out/, the whole site: capture.sh records what ovid
# prints, ovid builds gen, and gen renders the pages. Each step prints JSON
# lines; the first that fails stops the build.
set -eu
cd "$(dirname "$0")"
./capture.sh
ovid=.cache/bin/ovid
"$ovid" test
"$ovid" build -o .cache/bin/gen | tee captured/gen-build.jsonl
rm -rf out
.cache/bin/gen
