# Roadmap

Ovid's first commit is from 2026-10-03. v0 is the smallest language that can compile itself, and the toolchain around it; most of what it lacks, it lacks because it is new.

## Committed

These are recorded in [COMMITMENTS.md](https://github.com/ovid-sh/ovid/blob/main/COMMITMENTS.md) and not implemented yet.

- **HTTP as the first standard library.** Network is part of the language: the best HTTP client, harder to misuse than Go's `net/http`.
- **URL imports.** The import syntax stays and the path is still the package name; a path that is a URL is fetched with the HTTP capability instead of read from the module directory.
- **Serving programs.** The same capability serves user programs. When it does, this site will be served by one.

## Not there yet

The language reference describes v0 by what it does not have. None of it is ruled out:

- strings, slices, arrays, and struct values
- globals, closures, function pointers, methods, and generics
- more than six parameters, or more than one result
- `for`, `break`, and `continue`
- targets other than Linux x86-64
- a package server

## Not on this site yet

- the command protocol as a page, from `docs/PROTOCOL.md`
- the agent tasks and every recorded run, from `tests/agent` and `docs/agent-runs`
- the self-hosted compiler's size and build times, from ovid's CI benchmark
