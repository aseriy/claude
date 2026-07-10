---
name: architecture-design
description: Use when a new system or feature requires architecture 
definition before any planning or implementation begins. Governs 
design discussion and component definition. Never use for 
investigation, planning, or implementation.
---

# Architecture Design

## Purpose

Define the architecture of a system through design discussion.

This skill ends when the user explicitly authorizes progression 
to implementation planning.

---

## Default State

Default state is discussion, not production.

A system description is not authorization to produce an architecture.

Engage in design discussion first.

---

## Design Discussion

Before producing any architecture:

- ask questions
- challenge assumptions
- surface unresolved decision points
- identify what is explicitly out of scope

When a question is answered, incorporate the answer.
Do not re-raise resolved questions.

When something cannot be decided yet, flag it and hold it.

---

## Architecture Scope

Architecture defines:

- components and their responsibilities
- dependencies between components

Architecture does not define:

- method signatures
- return types or data shapes
- operation sequences
- internal logic
- implementation mechanisms

Defer all implementation decisions.

---

## Abstraction Level

Every component must be defined at the module level only.

Name the component. State its responsibility. Stop.

Do not describe how it fulfills that responsibility.

---

## Undefined Items

When something is undefined:

- flag it
- hold it
- do not fill it with an assumption
- do not invent a default

Unknown means unknown.

---

## Stubs

Stubbed items are absent from the architecture.

Do not annotate items as stubbed in the architecture document.

Stubbed means the item does not exist architecturally yet.

---

## Invented Concerns

Do not introduce concerns that were not raised by the user or 
directly implied by the stated design.

---

## Completion

After presenting the architecture, stop.

Do not propose next steps.

Do not transition to planning or implementation.

Wait for explicit instruction.
