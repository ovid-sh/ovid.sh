# Start

Ovid builds wherever Go does; the programs it compiles run on Linux x86-64. Other targets are [not there yet](/roadmap).

## Install

```sh
git clone https://github.com/ovid-sh/ovid
cd ovid
go build -o bin/ovid ./cmd/ovid
```

The toolchain needs nothing beyond Go. Elsewhere it still checks, edits, and builds Linux binaries; `run` and `test` need Linux x86-64 to run what it built.

## A module

```console include=captured/demo-init.txt
```

A module is a directory with `ovid.mod`. Each directory of `.ov` files in it is one package, named by its path. `init` writes a main and a test:

```ov include=captured/hello-main.ov.txt
```

```ov include=captured/hello-main_test.ov.txt
```

## Run and test

```console include=captured/demo-run.txt
```

```console include=captured/demo-test.txt
```

Each test runs in its own process and passes by returning 0. A failure names the `return` that produced it; a crash, its signal, statement, and call stack.

## Give it to an agent

`ovid help` is written for an agent to read first, and each topic it names is the reference for that part. This site has them all in one file, [llms-full.txt](/llms-full.txt).

```text include=captured/help.txt
```
