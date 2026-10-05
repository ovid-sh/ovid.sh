#!/bin/sh
# capture.sh builds the ovid named in OVID_COMMIT and records what it
# prints into captured/, which gen renders. Nothing on the site that looks
# like ovid output is typed by hand: it comes from here.
#
#   OVID_REPO=../ovid ./capture.sh     use a local clone instead of GitHub
set -eu

root=$(cd "$(dirname "$0")" && pwd)
commit=$(cat "$root/OVID_COMMIT")
repo=${OVID_REPO:-https://github.com/ovid-sh/ovid.git}
src=$root/.cache/ovid
ovid=$root/.cache/bin/ovid
out=$root/captured

if [ ! -d "$src/.git" ]; then
  git clone --quiet "$repo" "$src"
fi
if ! git -C "$src" cat-file -e "$commit^{commit}" 2>/dev/null; then
  git -C "$src" fetch --quiet "$repo"
fi
git -C "$src" -c advice.detachedHead=false checkout --quiet "$commit"
(cd "$src" && go build -o "$ovid" ./cmd/ovid)

rm -rf "$out"
mkdir -p "$out"
echo "$commit" > "$out/ovid-commit.txt"

for t in language commands edit std ids; do
  "$ovid" help "$t" > "$out/help-$t.txt"
done
"$ovid" help > "$out/help.txt"

# The demos run in a scratch module. step prints the command as a shell
# prompt line, then what ovid printed, then its exit code when not 0.
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
step() {
  echo "\$ ovid $*"
  set +e
  "$ovid" "$@" 2>&1
  code=$?
  set -e
  if [ "$code" != 0 ]; then
    echo "exit $code"
  fi
}
# stepin is step with code on stdin, shown as a heredoc.
stepin() {
  code=$1
  shift
  echo "\$ ovid $* <<'EOF'"
  printf '%s\nEOF\n' "$code"
  set +e
  printf '%s\n' "$code" | "$ovid" "$@" 2>&1
  code=$?
  set -e
  if [ "$code" != 0 ]; then
    echo "exit $code"
  fi
}
# Absolute paths name the scratch dir; show them relative to it.
scrub() {
  sed "s|$work/||g"
}

cd "$work"
step init hello | scrub > "$out/demo-init.txt"
cd hello
cp hello/main.ov "$out/hello-main.ov.txt"
cp hello/main_test.ov "$out/hello-main_test.ov.txt"
{
  step run
  step build
} | scrub > "$out/demo-run.txt"
step test | scrub > "$out/demo-test.txt"

cat > hello/extra.ov <<'EOF'
package hello

func Twice(n i64) i64 {
  return n + n
}

func Use() i64 {
  return Twice(1, 2)
}
EOF
step check | scrub > "$out/demo-check.txt"
rm hello/extra.ov

# Two agents read Greeting; b changes it; a's edit, made from what it read
# before, is refused with the current text.
hash=$("$ovid" outline --pkg hello | sed -n 's/.*"hash":"\([0-9a-f]*\)","id":"fn:hello.Greeting".*/\1/p')
{
  step show Greeting
  echo "# agent b"
  stepin '  return strptr("hello, agents\n")' replace st:hello.Greeting:1 --expect "$hash"
  echo "# agent a, from what it read before"
  stepin '  return strptr("hi\n")' replace st:hello.Greeting:1 --expect "$hash"
} | scrub > "$out/demo-stale.txt"

echo '{"ok":true,"captured":"'"$out"'","ovid":"'"$commit"'"}'
