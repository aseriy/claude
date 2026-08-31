---
name: repository-plan-changes
description: Use when the user explicitly requests a plan, proposal, outline, or revision for a change to existing repository code. Coordinates repository investigation, architecture assessment, repository coding requirements, and applicable language-specific coding requirements. Planning only. Never implement or modify files.
---

# Repository Change Planning

## Purpose

Produce a repository-grounded implementation plan for an explicitly requested code change.

This is a composite workflow. It owns the sequence and completion of the planning task.

Component skills supply evidence and constraints. They do not independently terminate this workflow.

## Scope

Use for explicit requests to:

- plan a repository change
- propose a repository modification
- outline an implementation
- revise or review an existing repository change plan

Do not infer a planning request from discussion, investigation, architecture description, or future intent.

Planning does not authorize implementation.

## Required Sequence

### 1. Investigate

Invoke `repository-investigation` before any repository inspection.

Use it to:

- inspect the exact code in scope
- establish current behavior
- trace relevant program and data flow
- identify the nearest local implementation precedent
- gather the evidence required to plan the change

Do not plan from conversation memory or prior summaries when the repository can be inspected.

### 2. Assess Architecture

After investigation, determine whether the requested change affects any of the following:

- component responsibilities
- component boundaries
- dependencies between components
- interfaces or contracts between components
- ownership or flow across components

If any are affected, invoke `architecture-design` and apply its architectural constraints before planning implementation details.

If none are affected, do not invoke `architecture-design`.

### 3. Apply Repository Coding Requirements

Invoke `repository-coding`.

Apply its relevant requirements to the proposed implementation, including:

- scope discipline
- local precedent
- identifier accuracy
- minimal change
- repository vocabulary
- reuse before creation
- pattern replication

Implementation authorization gates file modification. It does not prevent these requirements from governing an implementation plan.

### 4. Apply Language Requirements

Identify every programming language present in the code being changed.

Invoke every installed language-specific skill named `repository-coding-<language>` that matches those languages.

Apply its relevant coding, design, and structural requirements to the proposed implementation.

Do not guess the language and do not invent a missing skill.

### 5. Produce the Plan

Produce the implementation plan only after all required skills have been invoked and applied in the sequence above.

Follow the planning requirements in `CLAUDE.md`.

## Component Skill Boundaries

Within this composite workflow:

- `repository-investigation` supplies evidence but does not author the plan.
- `architecture-design` supplies architectural constraints but does not define code-level mechanics.
- `repository-coding` supplies repository implementation requirements but does not authorize editing.
- Language-specific coding skills supply language requirements but do not authorize editing.

A component skill's prohibition against planning means that the component does not produce the final plan itself.

It does not make that component inapplicable to this composite workflow.

Standalone completion or stop instructions in component skills do not terminate this workflow. Continue with the next required step.

## Output

Keep the plan proportional to the requested change.

Include only:

- the implementation approach
- the exact files, symbols, or areas to change when established by evidence
- the relevant existing pattern to follow
- ordered implementation steps
- unresolved facts that prevent a grounded implementation decision

Do not include:

- code changes
- unauthorized plan artifacts
- generic background
- a narration of skill usage
- search-command inventories
- a testing or verification section unless explicitly requested
- unrelated improvements or follow-up work

## Completion

Present the plan and stop.

Do not implement the change.
