# Friction

What got in the way of writing gen in Ovid. Each entry is a finding for
ovid: a missing feature, or a message that sent the writer the wrong way.
Newest first; date each one and name the ovid commit.

## 2026-10-05, ovid f871036: gen, first version

gen is about 1,400 lines in three packages (`gen`, `md`, `text`), written
by an agent (claude-opus-5-5 in Claude Code) with the Write tool, checked
with `ovid check` and `ovid test`. Like the agents in ovid's
`docs/AGENT_FEEDBACK.md`, it did not navigate or edit through `ovid
outline`, `show`, or `edit`: it was writing new files, not changing code
it had to find.

- **A misleading message for a two-segment import.** `test.True(...)`,
  with `import ovid/test`, is reported as `syntax`: "methods are not in
  v0". The fix is `ovid/test.True(...)`; the message should say so, as the
  hint for other qualified names does.
- **No char literals.** `text` declares 26 consts (`NL`, `BQ`, `PIPE`, ...)
  so that the parsers can compare bytes by name.
- **Every literal twice.** `strptr("…")` and `strlen("…")` repeat the
  text; the tests in `md/md_test.ov` repeat 100-byte literals, and a typo in
  one copy is a wrong length, not an error. `text.S` takes a literal's
  length from its NUL instead.
- **No arrays or slices.** The page list is a linked list of `Page`, walked
  by count.
- **One result.** `text.ReadFile` returns a `*Span` for data and length;
  the alternative is two out-param cells.
- **No exec.** gen cannot run ovid, so recording ovid's output is a shell
  script (`capture.sh`) and gen reads the files it leaves.
- **Every `.ov` file in a module is a package.** Captured Ovid sources
  failed `ovid test` with `layout` errors until they were stored as
  `.ov.txt`. This is the rule working; a module has no place for `.ov`
  data.
