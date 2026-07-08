---
name: repository-coding
description: Use when implementing, modifying, or refactoring code in the repository after implementation has been explicitly authorized. Never use for repository investigation or analysis.
---

# Repository Coding

## Purpose

Implement authorized changes to the repository.

This skill begins **after** repository investigation (if needed) has established sufficient evidence and the user has explicitly authorized implementation.

This skill is responsible for code changes only.

---

## Preconditions

Before making any code changes, verify all of the following:

- implementation has been explicitly authorized
- requested scope is unambiguous
- sufficient repository evidence has been gathered
- local implementation precedent has been reviewed

If any condition is not met, stop.

---

## Authorization

Implementation requires explicit authorization.

Approval of:
- analysis
- investigation
- explanation
- design
- proposal
- implementation plan

does **not** authorize code changes.

Before editing, identify the exact authorization from the conversation.

---

## Scope Discipline

Modify only what the user requested.

Do not:

- expand scope
- perform adjacent cleanup
- refactor unrelated code
- improve nearby code
- implement "the obvious next step"
- infer integration work

The current request defines the entire implementation scope.

---

## Local Precedent

Before introducing new code:

- inspect nearby implementations
- follow existing repository conventions
- reuse established patterns

Repository precedent takes priority over general engineering preferences.

---

## Evidence First

Do not implement based on assumptions.

If repository evidence is insufficient:

stop and investigate first.

Unknown is preferable to guessed.

---

## Identifier Accuracy

Use repository identifiers exactly as defined.

Never:

- normalize names
- shorten identifiers
- invent APIs
- assume object structure

---

## Implementation Style

Prefer:

- minimal edits
- surgical changes
- existing architecture
- existing coding style

Avoid unsolicited:

- refactoring
- formatting changes
- logging
- comments
- renaming

---

## Tool Discipline

Only use tools required for the authorized implementation.

Discovery does not authorize execution.

If a required tool fails:

stop.

Do not substitute another approach unless explicitly authorized.

---

## Completion

When implementation is complete:

- stop after the authorized scope
- do not continue with additional improvements
- do not suggest or perform follow-up implementation unless requested

---

## Repository Vocabulary

Treat the repository's existing names as canonical.

Before introducing a new:

- function
- method
- class
- interface
- type
- variable
- constant
- file
- directory

search for equivalent implementations or concepts.

If an equivalent exists, reuse its naming unless the user explicitly requests otherwise.

Do not create synonyms for the same concept.

---

## Reuse Before Create

Before introducing any new function, helper, class, utility, or non-trivial logic:

1. Search the current file for existing functionality that fully or partially satisfies the requirement.
2. If none exists, search nearby repository code.
3. Prefer reusing or extending existing implementations over creating new ones.
4. Do not duplicate behavior under a different name, signature, or implementation.
5. If existing code can satisfy the requirement with a localized modification, modify it instead of introducing a parallel implementation.
