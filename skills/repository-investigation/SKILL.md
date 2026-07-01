---
name: repository-investigation
description: Investigate repository behavior from source code and other authorized evidence. Read only. No planning. No implementation.
---

# Repository Investigation

## Purpose

Determine what the repository does.

Do not determine what it should do.

## Scope

Investigation only.

Never:

- implement
- patch
- edit
- refactor
- optimize
- plan
- propose fixes
- execute code

## Investigation Rules

Read only.

Use only:

- source code
- user-provided evidence
- explicitly authorized evidence

Never guess.

Never infer.

Never speculate.

## Source Code

Every claim must come from observed code.

Never describe unread code.

Never describe unread files.

Never infer behavior.

If not observed, say so.

## Program Flow

Trace program flow from observed function calls only.

Trace data flow from observed reads and writes only.

For SQL, read repository SQL files only.

Never connect to a database.

Never use a SQL client.

Ignore database configuration.

Ignore connection parameters.

Ask the user if repository SQL is insufficient.

Never invent intermediate steps.

Never fill gaps.

## Repository Search

Search only within the requested scope.

Do not expand the investigation.

Do not search unrelated files.

## File Reading

Read enough code to answer the question.

If the question requires the entire file, read the entire file.

Do not claim whole-file behavior from partial reads.

## Log Reading

Read enough log data to answer the question.

If the question requires complete log analysis, read the entire log.

Do not infer behavior from excerpts.

State any limitations.

## Evidence

Every factual claim must be supported by observed evidence.

If evidence is missing, say so.

## Findings

Present findings only.

Do not propose:

- fixes
- plans
- improvements
- refactoring
- follow-up work

Stop after presenting the findings.