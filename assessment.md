## Overall assessment

**Strengths**

* Excellent focus on conversation-state management.
* Strong protection against premature implementation.
* Clear separation between discussion, planning, and execution.
* Heavy emphasis on evidence-based reasoning.
* Good defenses against "assistant momentum" (the tendency to keep moving work forward).

These address several common LLM failure modes, especially for coding assistants.

---

## Major issues

### 1. Excessive duplication (largest problem)

Many concepts appear repeatedly with slightly different wording.

Examples include:

* investigation mode
* implementation authorization
* planning authorization
* scope boundaries
* don't infer tasks
* don't manufacture forward motion
* answer then stop
* evidence requirements
* local precedent
* implementation approval

Several of these are repeated 5–10 times.

For Claude, this has two downsides:

* increases prompt length
* creates competing phrasings for essentially the same rule

Claude generally performs better with one authoritative rule than many overlapping ones.

---

### 2. Instruction collisions

Some rules conflict.

Example:

Early sections:

> Investigation ends only when user explicitly says to implement.

Later:

> "Proceed" may authorize implementation depending on context.

Later again:

> Approval of a plan is NOT approval to implement.

Later:

> Proceed (after plan) usually authorizes implementation.

Those aren't fully consistent.

A model now has to reconcile multiple authorization systems.

---

### 3. Priority inversion

The strongest rules are near the beginning.

But hundreds of later rules continue redefining behavior.

Claude generally pays more attention to:

* earliest instructions
* most concrete instructions
* shortest rules

Later repetitions dilute the earlier signal.

---

### 4. Over-specification

Many rules exist because they defend against one previous model failure.

For example:

> Never shorten identifiers.

> Never normalize identifiers.

> Never canonicalize identifiers.

> Never simplify identifiers.

Those could be one rule.

The same happens throughout the file.

---

### 5. Negative-only guidance

Much of the prompt says:

* don't
* never
* forbidden
* prohibited

Claude usually performs better when a constraint is paired with the desired behavior.

Example:

Instead of:

> Do not infer implementation.

Prefer:

> Treat discussion as discussion. Execute only after explicit implementation authorization.

Positive constraints are easier for the model to follow consistently.

---

## Claude-specific observations

### Excellent

Speech Act Classification is particularly strong.

Claude responds well to explicit intent classification.

That section is probably one of the highest-value parts of the document.

---

### Excellent

Conversation State

Discussion

↓

Investigation

↓

Planning

↓

Implementation

This explicit state machine fits Claude's reasoning style well.

---

### Less useful

Mandatory checklists repeated dozens of times.

Claude already internally reasons through instructions.

Very long repeated checklists often become background noise.

---

### Less useful

Many "STOP immediately" instructions.

One clear stopping protocol is usually enough.

Twenty versions of it don't improve compliance much.

---

## Structural issues

The file has gradually evolved instead of being designed as one document.

You can see layers:

1. conversation semantics
2. investigation
3. implementation
4. plans
5. evidence
6. repository inspection
7. authorization
8. code grounding
9. plan mode
10. literal identifiers
11. tool restrictions
12. approval semantics
13. more authorization
14. more investigation

Many later sections restate earlier sections.

---

## Token efficiency

This file is approximately **38,000 characters**, roughly **9,000–10,000 tokens** depending on tokenization. 

For Claude Code, that's significant because `CLAUDE.md` is part of the prompt context on each turn.

A careful consolidation could likely reduce it to **3,000–5,000 tokens** while preserving nearly all of its behavioral effect.

---

## Highest-value sections

If I were ranking them:

1. Conversation Semantics Protocol
2. Speech Act Classification
3. User Controls Investigation
4. Explicit Authorization Requirement
5. Mandatory Scope Verification
6. Evidence Before Claims
7. Local Precedent
8. Investigation Mode
9. Plan Mode
10. Approval Semantics

These encode the core behavioral model.

---

## Lowest-value sections

The least valuable are the repeated variants of:

* "Don't manufacture forward motion."
* "Answer then stop."
* "Don't infer implementation."
* "Implementation requires authorization."
* "Unknown means unknown."
* "No unverified code claims."

Each is individually useful, but they appear often enough that they're better expressed once as canonical rules with later sections referring back to them.

## Overall

From a Claude optimization perspective, I'd rate it:

* **Behavioral quality:** 9.5/10
* **Coverage:** 10/10
* **Maintainability:** 5/10
* **Token efficiency:** 4/10
* **Internal consistency:** 7.5/10

The main opportunity is not adding more rules, but consolidating existing ones into a smaller set of authoritative principles. That would reduce context usage and likely improve adherence by reducing instruction overlap.
