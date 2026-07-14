---
name: repository-coding-python
description: Apply when writing or modifying Python code in any repository. Defines the required project structure, CLI patterns, coding style, and architectural conventions to follow.
---

# Repository Coding — Python

## Purpose

Enforce consistent Python coding style, design patterns, and
architectural conventions across all projects.

---

## Project Structure & Packaging

- Package with a top-level CLI module, an `operations/` subpackage,
  and an optional pluggable subpackage for swappable implementations
- Poetry build backend; dependencies pinned with exact `==` versions
  in the `[project]` table; `requires-python` pinned to a minimum
  patch version
- Console script registered under `[tool.poetry.scripts]` pointing
  to the CLI entry point
- Docker: `python:x.x-slim` base, `PYTHONDONTWRITEBYTECODE=1` and
  `PYTHONUNBUFFERED=1`, install from a pre-built wheel, `ENTRYPOINT`
  runs the CLI command

---

## CLI Framework & Patterns

- Click is the CLI framework
- Custom `click.Group` subclass to override help section header
- Root group declared with
  `@click.group(cls=..., options_metavar=..., subcommand_metavar=...)`
  and an empty body
- Entry guard: `if __name__ == "__main__": cli()`

---

## Commands, Subcommands & Option Decorators

- Reusable option sets as plain decorator functions: take `f`, apply
  `click.option(...)(f)` repeatedly, return `f`; stacked above commands
- Commands registered via `@cli.command(short_help=...)`
- Short flag + long flag + dest naming on every option
- Nested subgroups via `@cli.group(...)` with a pass body;
  subcommands via `@subgroup.command(...)`
- Mutually exclusive flags raise `click.UsageError`

---

## CLI-to-Operations Delegation

- Each command normalizes inputs, builds one `args` dict of
  string-keyed values, calls a single `run_*(args)`
- No business logic in the CLI layer
- Key remapping done per-command as needed before building `args`

---

## Operations Module Organization

- `operations/__init__.py` imports all public `run_*` functions from
  submodules and declares an explicit `__all__`
- Public entry per operation: `run_<name>(args: dict)`, returns `None`
- Internal helpers take unpacked parameters, not the `args` dict
- Shared utilities isolated in `common.py`; all operations import
  from `.common`

---

## Coding Style

- Imports: stdlib first, third-party next, relative last; occasional
  grouped one-liners for closely related stdlib modules
- Type hints on function signatures and return types; `Optional`,
  `Iterable`, `Tuple`, `Any` from `typing`; not exhaustive
- Naming: `snake_case` for functions and variables; `run_*` prefix
  for public operation entry points; `_leading_underscore` for
  module-level globals; `UPPER_CASE` for constants
- Error handling: `raise RuntimeError(f"...")` for validation
  failures; retry loops with incremental backoff and jitter; warnings
  and errors accumulated in lists and written to timestamped log
  files; `response.raise_for_status()` on HTTP calls
- String formatting: f-strings throughout; multi-line strings as
  triple-quoted with `textwrap.dedent().strip()`
- Logging: use the `logging` module for all application output;
  configure a logger per module with `logging.getLogger(__name__)`;
  use appropriate levels — `logger.info`, `logger.warning`,
  `logger.error`, `logger.debug`; do not use `print` for
  application output
- Comments: inline `#` notes, numbered step comments,
  `# end if` / `# end for` block markers, `TODO:` markers,
  commented-out debug lines left in place
- Spacing: two blank lines between top-level functions; generous
  vertical whitespace between logical blocks within functions
- SQL: `%s` placeholders with param tuples for dynamic values;
  identifiers f-string interpolated directly

---

## Config Handling

- YAML template file documents the expected config shape as a
  reference
- Config loaded at module level from
  `Path.cwd().joinpath("config.yaml")` using `yaml.safe_load`
- Each pluggable module selects its own config block by matching on
  its module stem (`Path(__file__).stem`)

---

## Pluggable Module Pattern

- Modules loaded dynamically by name via `importlib.import_module`
- Validity gated by a helper that enumerates available modules using
  `pkgutil.iter_modules`
- All pluggable modules implement the same duck-typed contract —
  same function names and signatures
- Dual execution mode driven by an environment variable: local
  in-process vs. remote HTTP; remote branches use
  `inspect.currentframe().f_code.co_name` as the endpoint path
- Optional companion YAML deployment spec per pluggable module
- Standalone test harness as a `@click.command()` that imports a
  module by name and exercises each contract function
  