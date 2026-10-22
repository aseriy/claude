Audit complete. Report and proposed diff follow. No file was changed.

  Scope, target, and summary

  Assumptions. Scope is the Claude Code configuration that loads in this project. Target model is claude-fable-5-1, the model running this session.
  Inventory found and read:
  
  - ~/.claude/CLAUDE.md, 1336 lines. Loads in every project, so every edit below affects all projects.
  - User skills, all read: architecture-design, repository-investigation, repository-coding, repository-coding-python, repository-plan-changes,
    technical-writing, user-led-talk-prep.
  - Plugin skills, report only: Miru miru, ste, caveman, aws-transform-modernization.
  - Not present: project CLAUDE.md, CLAUDE.local.md, AGENTS.md, ancestor files under /home/ubuntu/git, managed /etc/claude-code/CLAUDE.md.
  - Not enumerable: ~/.claude/rules, commands, agents, output-styles. The shell sandbox denies listing ~/.claude. If files exist there, they are
    unaudited. The project's .claude/agents, commands, skills, output-styles entries are sandbox device nodes, excluded.
  - Not read: settings files and .mcp.json, per the request. Bundled Claude Code skills (code-review, simplify, and others) were not read.
  - Provenance: git blame was not available. ~/.claude is outside the project and the shell cannot read it.

  Highest-impact findings. The global CLAUDE.md rules on the same point twice with different answers in two places: the open-question sorting (four
  states at line 675, three states at line 706) and skill activation (explicit request only at line 115, all skills always binding at line 836). Both are
  intra-file contradictions, and the Claude Code memory documentation states that on a contradiction the model "may pick one arbitrarily". Third, the
  file names a tool, read_file, that this agent does not have. The one pattern I examined and did not flag: the banned-phrase lists at lines 252 to 263
  and the filler prohibitions. The failure they guard against reproduced in this session, so under the audit's keep list they stay.

  Counts. Group 1: 2 findings. Group 2: 4 findings. Group 3: not applicable, no tool descriptions in scope. Group 4: not applicable, no request code; no
  subagent definitions were reachable. Flags: 7.

  Findings

  #: 1
  Location: ~/.claude/CLAUDE.md:675-683 and :706-711                 
  Evidence: "Sort every open question into one of four states" and, 31 lines later, "Sort every open question into one of three states" with a different
  list. Lines 700-704 and 716-718 repeat lines 656-658 and 690-692 nearly verbatim.
  Pattern: Group 2, instruction files that contradict each other, same file
  Why obsolete: Two sorting schemes for the same step load together on every turn. The memory docs state a contradiction may be resolved arbitrarily.
  Confidence: High
  Action: rewrite: one merged list; delete the second draft
  ────────────────────────────────────────
  #: 2
  Location: ~/.claude/CLAUDE.md:115-117 vs :836
  Evidence: "Do not infer skill activation. Skill selection is determined by the user's explicit request." vs "treat every one of these skills as fully
  active and binding."
  Pattern: Group 2, contradiction, same file
  Why obsolete: repository-investigation is both "only on explicit request" and "always binding". Direction assumed: lines 93-121 control, since they 
  carry the per-skill reasoning. The user decides.
  Confidence: High
  Action: rewrite line 836
  ────────────────────────────────────────
  #: 3
  Location: ~/.claude/CLAUDE.md:827, :923, :978
  Evidence: "cat, read_file, find, etc.", "find, grep, read_file", "the core read_file tool"
  Pattern: Group 2, volatile specifics: names that do not resolve
  Why obsolete: This agent's file tool is Read. read_file is another agent's name. The rule at line 978 directs a fallback to a tool that does not exist
  here.
  Confidence: Medium
  Action: rewrite to Read
  ────────────────────────────────────────
  #: 4
  Location: ~/.claude/CLAUDE.md:548-550, :796-797, :911, :9, :15
  Evidence: "<what the patch actually did>{=html}", "theoperator", "IMMEIDATELY"
  Pattern: Group 2, brittle file: converter residue and typos
  Why obsolete: {=html} is a Pandoc attribute, not an instruction. It appears inside the required response formats, so the model reads it as part of the
  format.
  Confidence: Medium
  Action: rewrite
  ────────────────────────────────────────
  #: 5
  Location: ~/.claude/CLAUDE.md:13, :15, :508, :599, :825, :849, :918, :928, :964, :1070, :1087, :1099, :1113
  Evidence: "no exceptions!", "IMMEIDATELY!!!", "strictly forbidden" (7 occurrences), "structurally banned", "non-negotiable", "hard failure"
  Pattern: Group 1a, pressure language
  Why obsolete: Current models follow the system prompt literally; emphasis on every rule stops carrying information and sets a cautious register. The
  constraints stay. The volume goes.
  Confidence: Medium
  Action: rewrite, replacements below
  ────────────────────────────────────────
  #: 6
  Location: ~/.claude/CLAUDE.md:768-770, :845-849; ~/.claude/skills/technical-writing/SKILL.md:71-73
  Evidence: "silently verify", "Mandatory Self-Check Pass: run the draft through a dedicated evaluation pass", "Before returning the response, run one
  pass over the draft"
  Pattern: Group 1b, prose that scripts the model's internal reasoning
  Why obsolete: On claude-fable-5-1 thinking is always on and depth is set by the harness effort level, not by prose. The pass leaves no trace, so
  nothing
  can confirm it ran. The requirement behind it is load-bearing and stays, stated as a requirement.
  Confidence: Medium
  Action: rewrite
  ────────────────────────────────────────
  #: 7
  Location: ~/.claude/CLAUDE.md:481, :801-803, :1242-1245
  Evidence: "cursor.execute(...)", "split_block() receives term_tc_table", "update_bmw_blocks()", "tsv_dict"
  Pattern: Group 2, volatile specifics from another project in a global file
  Why obsolete: Illustrative, so keep-list item 7 protects them. Risk: Identifier Literalism forbids identifiers not observed in source, and these are
  never observed.
  Confidence: Low
  Action: flag
  ────────────────────────────────────────
  #: 8
  Location: ~/.claude/CLAUDE.md:1187-1189
  Evidence: "requires git mv, which this session cannot run"
  Pattern: Group 2, history narrative: a one-session fact stated as permanent
  Why obsolete: Whether git mv runs depends on sandbox and permission settings per session.
  Confidence: Low
  Action: flag
  | 9 | ~/.claude/skills/repository-coding-python/SKILL.md:93-95 vs ~/.claude/skills/repository-coding/SKILL.md:112-118 and ~/.claude/CLAUDE.md:1117-1119
  | "numbered step comments, # end if / # end for block markers" vs "Do not introduce unsolicited: comments" | Group 2, conflict across instruction
  files | For new Python code, one file requires block-marker comments and two forbid unsolicited comments. The Python skill is narrower by language but
  names no override. | Low | flag: the user decides whether block markers count as solicited |
  | 10 | ~/.claude/CLAUDE.md, whole file | 1336 lines | Not a pattern row. Context only. | The Claude Code memory page states files over 200 lines
  "reduce adherence". The audit guide forbids deletions justified by length, so no edit is proposed on this basis. | Low | flag |
  | 11 | Harness plan-mode reminder vs ~/.claude/CLAUDE.md:734-735, :829, :1169-1176 | The injected plan-mode workflow requires Explore agents, a
  verification section, and ExitPlanMode each turn. The file forbids the plan tool without an explicit request and forbids verification sections. |
  Outside scope: the reminder is harness text, not an instruction file | Noted because it is the live source of conflicting instructions in this session.
  | Low | flag |
  | 12 | ~/.claude/plugins/cache/miru/miru/1.13.1/skills/aws-transform-modernization/SKILL.md:10 | "see docs/self-hosted-sagemaker.md" | Group 2,
  volatile path | Path is relative to the plugin, outside the project, not probed. | Low | flag, plugin file, report only |
  | 13 | ~/.claude/rules, commands, agents, output-styles | Not enumerable from this session | Inventory gap | Unknown whether files exist. | Low | flag
  |

  Not flagged after examination: the forbidden-phrase lists at lines 252-263, 1239-1240 and the filler prohibitions (keep-list item 5, failure reproduced
  this session); the device-node exclusion at repository-investigation/SKILL.md:87-97 (environment fact, observed true here);
  repository-plan-changes/SKILL.md:33 invoking repository-investigation without a user request (an override that names its components at lines 91-104);
  user-led-talk-prep allowing "mostly" where CLAUDE.md:812 forbids it (narrower task scope, an override); the /caveman arrow symbols (user-invoked mode).

  Proposed diff

  All hunks are in files under ~/.claude and affect every project. Nothing is applied.

  Hunk 1, finding 1. ~/.claude/CLAUDE.md:675-720. Replace lines 675-683 with the merged list and delete lines 700-719. Line 720 stays.

  -Sort every open question into one of four states and label it:
  +Sort every open question into one of five states and label it:

   -   Settled from the repository. Cite the file and the exact
       identifier.
   -   Settled from published documentation. Name the page and state the
       condition the answer depends on.
  +-   Readable but not yet read. Name the file. Read it before asking
  +    anything. This state is your work, not the user's. Do not put it
  +    in the list of probes.
   -   Probe. State the exact command and what its result would prove.
   -   Blocked. The question cannot be answered yet because the code to
       exercise it does not exist. Name the code that is missing.
  @@ lines 700-719 @@
  -The same rule applies to asking the user to run a command. Before
  -asking for a probe, check whether any file, schema, migration,
  -manifest, or document answers the question. If one does, read it. A
  -probe is only for facts that exist at runtime and are written down
  -nowhere.
  -
  -Sort every open question into one of three states and label it:
  -
  --   Settled from source. Cite the file and the exact identifier.
  --   Readable but not yet read. Name the file. Read it before asking
  -    anything.
  --   Runtime only. State the probe and what its result would prove.
  -
  -The middle state is your work, not the user's. Do not put it in the
  -list of probes.
  -
  -Do not ask for a probe built on a guessed name. If the table, column,
  -role, or path in the probe is not verified, read the source that
  -defines it first.
  -
   Do not ask the user to confirm a fact the source already settled.

  Hunk 2, finding 2. ~/.claude/CLAUDE.md:836. Assumption: Skill Activation at lines 93-121 controls.

  -Load the following skills at session start or re-start. You must immediately treat every one of these skills as fully active and binding.
  +Read the following skills at session start or restart. technical-writing governs every response. Each other skill governs a response when its own 
  trigger holds or the user names it, under Skill Activation above.

  Hunk 3, finding 3. ~/.claude/CLAUDE.md:827, :923, :978.

  -    necessary read tools (`cat`, `read_file`, `find`, etc.) to fully
  +    necessary read tools (`Read`, `Bash`, etc.) to fully
  @@
  -    (`find`, `grep`, `read_file`, etc.). You may only write your text
  +    (`Read`, `Bash`, etc.). You may only write your text
  @@
  -    a directory, you are still fully capable of using the core
  -    `read_file` tool for explicit paths you already know. Do not
  +    a directory, you are still fully capable of using the core
  +    `Read` tool for explicit paths you already know. Do not

  Hunk 4, finding 4. ~/.claude/CLAUDE.md:9, :15, :548-550, :796-797, :911.

  -If theoperator instructs you to load CLAUDE.md and/or skills, "load" means "read" - no exceptions!
  +If the operator instructs you to load CLAUDE.md and/or skills, "load" means "read".
  @@
  --   Concrete violation: `<what the patch actually did>`{=html}
  --   User request: `<what the user actually asked for>`{=html}
  --   Rule violated: `<matching rule>`{=html}
  +-   Concrete violation: `<what the patch actually did>`
  +-   User request: `<what the user actually asked for>`
  +-   Rule violated: `<matching rule>`
  @@
  -Format: - Claim: `<brief answer>`{=html} - Evidence:
  -`<exact identifier/function/expression/file observed>`{=html}
  +Format: - Claim: `<brief answer>` - Evidence:
  +`<exact identifier/function/expression/file observed>`
  @@
  --   "Implementation has been authorized by: `<exact user text>`{=html}"
  +-   "Implementation has been authorized by: `<exact user text>`"

  Hunk 5, finding 5. ~/.claude/CLAUDE.md, one replacement per line. Each constraint is kept.

  ┌──────┬──────────────────────────────────────────────────────────────────────────────────┬────────────────────────────────────────────────────┐
  │ Line │                                     Current                                      │                    Replacement                     │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 13   │ "at all times - no exceptions!"                                                  │ "at all times."                                    │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 15   │ "correct your behavior IMMEIDATELY!!!"                                           │ "correct your behavior in the same response."      │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 508  │ "## Current Request Scope Is Absolute"                                           │ "## Current Request Scope"                         │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 599  │ "A scope mismatch is a hard failure."                                            │ "A scope mismatch means the edit does not happen." │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  -If theoperator instructs you to load CLAUDE.md and/or skills, "load" means "read" - no exceptions! 
  +If the operator instructs you to load CLAUDE.md and/or skills, "load" means "read".
  @@
  --   Concrete violation: `<what the patch actually did>`{=html}
  --   User request: `<what the user actually asked for>`{=html}                            
  --   Rule violated: `<matching rule>`{=html}
  +-   Concrete violation: `<what the patch actually did>`
  +-   User request: `<what the user actually asked for>`
  +-   Rule violated: `<matching rule>`
  @@
  -Format: - Claim: `<brief answer>`{=html} - Evidence:                                     
  -`<exact identifier/function/expression/file observed>`{=html}
  +Format: - Claim: `<brief answer>` - Evidence:
  +`<exact identifier/function/expression/file observed>`
  @@
  --   "Implementation has been authorized by: `<exact user text>`{=html}"
  +-   "Implementation has been authorized by: `<exact user text>`"                         
  
  Hunk 5, finding 5. ~/.claude/CLAUDE.md, one replacement per line. Each constraint is kept.
  
  ┌──────┬──────────────────────────────────────────────────────────────────────────────────┬────────────────────────────────────────────────────┐
  │ Line │                                     Current                                      │                    Replacement                     │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 13   │ "at all times - no exceptions!"                                                  │ "at all times."                                    │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 15   │ "correct your behavior IMMEIDATELY!!!"                                           │ "correct your behavior in the same response."      │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 508  │ "## Current Request Scope Is Absolute"                                           │ "## Current Request Scope"                         │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 599  │ "A scope mismatch is a hard failure."                                            │ "A scope mismatch means the edit does not happen." │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 825  │ "You are strictly forbidden from drafting, outlining, or writing any plan until" │ "Do not draft, outline, or write a plan until"     │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 849  │ "the verification pass is non-negotiable"                                        │ "the skill applies in full"                        │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 918  │ "You are strictly forbidden from stating"                                        │ "Do not state"                                     │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 928  │ "you are structurally banned from writing any other number"                      │ "write that number and no other"                   │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 964  │ "you are strictly forbidden from finding an alternative method"                  │ "do not find an alternative method"                │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 1070 │ "You are strictly forbidden from defending"                                      │ "Do not defend"                                    │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 1087 │ "You are strictly forbidden from importing"                                      │ "Do not import"                                    │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 1099 │ "You are strictly forbidden from scouring"                                       │ "Do not scour"                                     │
  ├──────┼──────────────────────────────────────────────────────────────────────────────────┼────────────────────────────────────────────────────┤
  │ 1113 │ "You are strictly forbidden from refactoring"                                    │ "Do not refactor"                                  │
  └──────┴──────────────────────────────────────────────────────────────────────────────────┴────────────────────────────────────────────────────┘

  Hunk 6, finding 6. Three locations.
  
  --- ~/.claude/CLAUDE.md:768-770
  -## Mandatory Pre-Answer Checklist
  -
  -Before answering any code-related question, silently verify:
  +## Pre-Answer Requirements
  +
  +Every code-related answer meets all of the following:
  --- ~/.claude/CLAUDE.md:845-849
  -`Loading` a skill explicitly triggers the following mandatory workflow before any response is generated:
  -
  -1. Zero-Trust Verification: Stop and verify every claim directly against the source data or code. Do not reason forward from memory or treat
  inferences as facts.
  -2. Mandatory Self-Check Pass: You must run the draft through a dedicated evaluation pass against the skill's core principles (e.g., the
  technical-writing correctness rules) before streaming or finalizing the output.
  -3. Skipping Disallowed: A skill cannot be partially applied or skipped for speed. If the skill is loaded, the verification pass is non-negotiable.
  +A loaded skill applies in full to every response it governs. Every claim in such a response is verified against the source data or code, and an
  inference is labeled as one.
  --- ~/.claude/skills/technical-writing/SKILL.md:71-73
  -## Self-check
  -
  -Before returning the response, run one pass over the draft and verify it against each of the seven C's and the three guidelines. Fix what fails. Do
  not report the self-check to the user.
  +## Standard
  +
  +Every response meets the seven C's and the three guidelines. Do not describe this standard to the user.

  Findings 7 through 13 are flags. No diff is proposed for them. Step 7 verification was not run, since nothing was applied.
  