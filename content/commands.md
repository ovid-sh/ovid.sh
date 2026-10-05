# Commands

Every command prints JSON lines to stdout, one record a line, and the last line has `"ok"`. The exceptions are `help`, `show` without `--json`, and a program's own output under `run`. A consumer reads every line, takes the last as the result, and ignores keys it does not know: new keys are added, existing ones keep their meaning.

| exit | meaning |
|---|---|
| 0 | ok |
| 1 | errors |
| 2 | a stale edit: the code changed since it was read |
| 64 | usage |
| 124 | `run --timeout` ended the program |
| 125 | `run` could not build or start the program |

The contract the commands share, with every error code and receipt field, is [PROTOCOL.md](https://github.com/ovid-sh/ovid/blob/main/docs/PROTOCOL.md). This is `ovid help commands`:

```text include=captured/help-commands.txt
```
