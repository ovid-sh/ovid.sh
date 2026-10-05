# Language

This is what `ovid help language` prints, recorded from the ovid this site was built with. It describes v0, the language as it is today. What it lists as absent, such as strings, slices, struct values, methods, and generics, is [not there yet](/roadmap), not ruled out.

```text include=captured/help-language.txt
```

## Standard library

`ovid/io`, `ovid/mem`, and `ovid/test` ship inside the toolchain, and a module cannot replace them. This is `ovid help std`:

```text include=captured/help-std.txt
```
