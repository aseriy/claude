## Overall assessment

This is no longer just a `CLAUDE.md`; it is now a multi-artifact Claude Code policy system.

The architecture has moved from a single accumulated instruction file toward a layered control model:

* `CLAUDE.md` defines conversation governance, authorization, execution boundaries, evidence requirements, tool restrictions, and repository reasoning.
* `repository-investigation` defines read-only repository analysis.
* `repository-coding` defines authorized implementation behavior.

That is the right direction.

The strongest improvement is that skills are no longer theoretical. They now exist as concrete procedural documents, and they map cleanly to two distinct repository modes: investigation and implementation.

The remaining issue is that `CLAUDE.md` has not yet fully adjusted to the existence of the skills. It still contains many sections that now overlap with, duplicate, or partially restate the skill files.

---

# Strengths

## 1. Strong governance layer

The opening section remains the strongest part of the system.

It establishes:

* default conversation mode
* speech act classification
* user control
* authorization boundaries
* no forward motion
* no inferred execution

before any repository or implementation guidance appears.

That ordering is correct. Claude needs conversation-state control before it needs coding rules.

---

## 2. The skill split is conceptually correct

The two current skills represent the right first decomposition.

`repository-investigation` is read-only, evidence-first, and explicitly forbids:

* implementation
* patching
* editing
* refactoring
* planning
* proposing fixes
* executing code

`repository-coding` begins only after implementation has been explicitly authorized and focuses on:

* scope discipline
* local precedent
* identifier accuracy
* minimal edits
* reuse before create
* pattern replication

That separation is much cleaner than trying to encode all repository behavior directly in `CLAUDE.md`.

---

## 3. Authorization remains unusually strong

The system consistently distinguishes:

* discussion
* investigation
* planning
* implementation
* execution

This is one of the highest-value parts of the design.

Most Claude Code prompt failures come from unintended state transitions. This repo directly attacks that failure mode.

The policy repeatedly reinforces that:

* finding a bug does not authorize fixing it
* approving a plan does not automatically authorize implementation
* defining a task does not authorize execution
* discovering an executable action does not authorize performing it

That is exactly the kind of redundancy that improves model behavior, even if it costs tokens.

---

## 4. Evidence discipline is excellent

The combination of:

* Code Fact Grounding
* Identifier Literalism
* No Unverified Code Claims
* Required Evidence Format
* Partial File Reads Are Not Evidence Of Whole-File Behavior
* Investigation Completeness

creates a strong anti-hallucination framework.

The system is especially good at preventing Claude from making plausible repository claims from naming conventions, partial reads, or inferred architecture.

That matters more for code work than general prompt elegance.

---

## 5. `repository-coding` adds useful implementation-specific policy

The coding skill is not just a shorter copy of `CLAUDE.md`.

It adds valuable implementation-specific ideas:

* Repository Vocabulary
* Reuse Before Create
* Pattern Replication

Those are good skill-level rules. They are more procedural than constitutional, and they belong in a coding skill rather than the always-loaded prompt.

This is the clearest evidence that the skill architecture is becoming useful, not merely organizational.

---

# Weaknesses

## 1. Duplication is now the dominant structural issue

The main problem is no longer missing policy.

The main problem is repeated policy.

The following concepts appear in both `CLAUDE.md` and the skills:

* explicit implementation authorization
* scope discipline
* evidence before claims
* local precedent
* minimal edits
* stop after the requested scope
* no inferred follow-up work
* no execution from discovery

These are all good rules.

The issue is that once skills exist, some of these should become references rather than full restatements.

---

## 2. `CLAUDE.md` still contains skill-shaped procedure

Several sections in `CLAUDE.md` now look like they belong in skills:

* DIAGNOSTICS & INVESTIGATION MODE
* Mandatory Pre-Answer Checklist
* Required Evidence Format
* Plans
* Pre-Edit Local Precedent Gate
* Mandatory Scope Verification
* Approval-Gated Editing
* File Rewrite Prohibition
* Change Budget
* Code Analysis & Review Protocols

These sections are not wrong.

They are just no longer clearly universal. Many are procedural policies for repository investigation or repository coding. Those now have dedicated skill homes.

---

## 3. Skill activation is incomplete

`CLAUDE.md` explicitly describes when to use `repository-investigation`.

It does not equivalently describe when to use `repository-coding`.

That creates an asymmetry.

The coding skill has a clear description and strong content, but the main governance document does not give it the same first-class activation treatment as the investigation skill.

Given the current architecture, `CLAUDE.md` should probably define both:

* when `repository-investigation` activates
* when `repository-coding` activates

and then avoid duplicating the full procedures from either skill.

---

## 4. There is visible prompt contamination

The diagnostics section contains a conversational sentence:

> Would you like to adjust the wording of the mandatory response structure, or should we review other sections of your `CLAUDE.md` to ensure they match this strict style?

That does not belong in a policy document.

It appears to be assistant-output residue copied into `CLAUDE.md`.

This is a correctness issue, not just a style issue, because Claude may treat it as part of the active instruction set.

It should be removed.

---

## 5. The document is still tool-specific in places

The system has moved toward an evidence-based abstraction, but several sections still name concrete tools or environments:

* `cat`
* `find`
* `grep`
* `read_file`
* `ls`
* `git`
* `Explore`
* `bwrap`

Some of these references may be necessary for Claude Code.

But the document mixes two levels of abstraction:

* general policy: evidence, authorization, source-of-truth
* concrete mechanism: specific tools, agents, shell commands, sandbox failures

That makes the policy less portable and harder to reason about.

---

# Claude-specific observations

## Outstanding Speech Act Classification

Still the highest-value section.

It gives Claude an explicit intent classifier before any action is taken.

That is unusually important because Claude tends to be helpful by continuing the apparent workflow. This section prevents context from becoming execution.

---

## Outstanding Conversation-first philosophy

The prompt is unusually strong at treating conversation as conversation.

It directly addresses common Claude failure modes:

* over-answering
* restating instead of adding value
* converting context into tasks
* manufacturing next steps
* treating future-tense statements as instructions
* interpreting corrections as requests to redo technical work

This remains one of the most distinctive strengths of the repo.

---

## Outstanding Evidence philosophy

The evidence model is coherent and practical.

It does not merely say "do not hallucinate." It defines what counts as evidence:

* observed code
* exact identifiers
* source expressions
* read files
* inspected logs
* explicit user-provided facts

That specificity is valuable.

---

## Strong Skill boundary principle

The line:

> Skills extend capabilities. They do not extend authority.

is still one of the best architectural principles in the system.

It prevents the introduction of skills from becoming a hidden permission escalation mechanism.

That principle should remain in `CLAUDE.md`.

---

## Moderate Procedural overlap

The skills now make some `CLAUDE.md` material redundant.

The overlap probably improves obedience, but it lowers maintainability and increases the risk that one artifact will evolve without the others.

This is now the main tradeoff.

---

# Structural observations

The current hierarchy looks roughly like this:

1. Conversation governance
2. Authorization
3. User control
4. Scope boundaries
5. Repository investigation
6. Planning restrictions
7. Evidence requirements
8. Skill policy
9. Tool restrictions
10. Editing discipline
11. Code grounding

That hierarchy is coherent, but it is not yet cleanly distributed across artifacts.

The target hierarchy should probably be:

1. `CLAUDE.md`
   * conversation semantics
   * authorization model
   * user authority
   * skill activation
   * evidence principles
   * source-of-truth rules
   * tool authority boundaries

2. `repository-investigation`
   * read-only investigation procedure
   * evidence-gathering rules
   * file/log reading completeness
   * findings-only response behavior

3. `repository-coding`
   * implementation preconditions
   * local precedent
   * minimal edit discipline
   * reuse and pattern replication
   * completion behavior

That would preserve the current behavioral model while reducing always-loaded complexity.

---

# Readiness for skills

The repo has crossed the threshold where skill extraction is not only practical, but necessary.

The skills are good.

The next step is not adding more skills.

The next step is removing or compressing the sections of `CLAUDE.md` that the skills now own.

I would not move the core governance layer out of `CLAUDE.md`.

But I would move or reduce most workflow-level material.

---

# Highest-value sections

Current ranking:

1. Conversation Semantics Protocol
2. Speech Act Classification
3. User Controls The Investigation
4. Skill & External Procedure Policy
5. Approval Semantics
6. The User Is The Primary Source Of Truth
7. Code Fact Grounding
8. Identifier Literalism
9. No Unverified Code Claims
10. Current Request Scope Is Absolute
11. repository-investigation skill
12. repository-coding skill
13. Local Precedent Before General Knowledge
14. Discovery Does Not Authorize Execution
15. Do Not Infer Integration Work

---

# Lowest-value sections

The remaining candidates for consolidation are:

* duplicated implementation authorization language
* duplicated investigation-stop language
* duplicated evidence requirements
* duplicated local precedent requirements
* duplicated minimal-edit rules
* diagnostics response formatting
* exact mandatory pre-answer formatting
* tool-specific command references
* hard-coded line-count or change-budget rules

Again, these are not poor rules.

They are mostly good rules that now have too many homes.

---

# Overall

From a Claude optimization perspective:

* **Behavioral quality:** 9.8/10
* **Coverage:** 10/10
* **Maintainability:** 7/10
* **Token efficiency:** 5/10
* **Internal consistency:** 9/10
* **Artifact architecture:** 8.5/10

This revision represents a real architectural transition.

Earlier versions were primarily about improving Claude's behavior by adding rules. The current repo is now trying to become a maintainable policy system with reusable procedural skills.

That is the correct direction.

The main risk is that `CLAUDE.md` remains too large and too procedural even after the skills have been introduced.

The best next refactor is not more policy.

It is redistribution:

* keep governance in `CLAUDE.md`
* keep investigation procedure in `repository-investigation`
* keep implementation procedure in `repository-coding`
* remove accidental conversational residue
* make skill activation symmetrical
* replace duplicated sections with shorter authority-preserving references

The system is behaviorally strong.

It is now ready for consolidation.
