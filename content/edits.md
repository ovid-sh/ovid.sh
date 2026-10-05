# Edits

An agent can edit `.ov` files directly, and ovid will check them. It can also edit through ovid: name a node by id, say which version of it was read, and the edit is refused rather than applied to code that has changed since.

- **Ids.** A declaration's id is its name, `fn:pkg.Name`, and stays put. A statement's or expression's id is its position, `st:pkg.Func:3`, so an insert above it renumbers it.
- **Guards.** Every edit carries the hash that `outline` or `show` printed, the module revision, or an explicit `--force`. A statement's hash covers its whole declaration, so an edit cannot land on a statement that took another's id.
- **All or nothing.** A batch is planned, the module is reparsed and checked in memory, and nothing is written if any op is stale or the result has new errors.
- **Many writers.** Writers to one module take a lock on `ovid.mod` and replace files atomically. The lock does not make a stale read safe; the hash does.

## Ids

```text include=captured/help-ids.txt
```

## Batch edits

```text include=captured/help-edit.txt
```
