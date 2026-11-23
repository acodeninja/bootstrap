# bootstrap design docs

How this repo turns `./bootstrap.sh zig ../my-proj` into a project with a pinned
toolchain, a passing test suite, and a readable tour of everything the language gives
you to solve a kata with.

Read in this order:

| Doc                                          | Answers                                                         |
| -------------------------------------------- | --------------------------------------------------------------- |
| [overview.md](overview.md)                   | What does the tool do, end to end? What is it deliberately not? |
| [install.md](install.md)                     | The one-liners, and how remote and clone mode differ            |
| [cli.md](cli.md)                             | Exact CLI contract — arguments, flags, exit codes, output       |
| [template-contract.md](template-contract.md) | What is inside `templates/<id>/`, and how do I add one?         |
| [containers.md](containers.md)               | How the language gets installed, and which image each one uses  |
| [kitchen-sink.md](kitchen-sink.md)           | What is in the shipped test, and why that?                      |
| [languages.md](languages.md)                 | The 49 targets, their tooling, and when each lands              |
| [ci.md](ci.md)                               | CI in the generated project, and CI that proves this repo works |
| [roadmap.md](roadmap.md)                     | Build order                                                     |

## The 60-second version

```console
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/acodeninja/bootstrap/main/bootstrap.sh)" -- zig ../my-zig
==> fetch        acodeninja/bootstrap @ main (49 templates)
==> template     Zig
==> preflight    docker 29.9.3, make 4.4.1
==> scaffold     14 files -> ../my-zig
==> git          initialised, 1 commit
==> image        pulled ghcr.io/acodeninja/bootstrap/zig:main
Build Summary: 5/5 steps succeeded; 16/16 tests passed

Ready. Next:
  cd ../my-zig
  make test
  read src/kitchen_sink.zig for the language, then pick a kata:
  https://learn.madetech.com/technology/katas/
```

You need Docker and `make`. You do not need Zig, and you do not need a clone of this
repo — that is the point.

The generated project has no dependency on this repo either. It is yours from the first
commit.
