INSERT INTO intent_enum
    (name, tools, skills, decision, proceed, suppress_output,
     additional_context, reason, system_message, stop_reason)
VALUES
    (
        'web',
        ARRAY['WebSearch', 'WebFetch'],
        NULL,
        true,
        true,
        false,
        'Answer from the web only.{%- if tools %} Use {{ tools | join(" or ") }} before answering.{% endif %} Cite the URL for every factual claim, and cite only URLs you retrieved in this turn. If the results don''t answer the question, say so and stop. Do not answer from memory.',
        'Blocked.{%- if tools %} Search with {{ tools | join(" or ") }}, then answer{% else %} Answer{% endif %} only from what you retrieved, citing URLs from this turn''s results.',
        'Intent: web',
        NULL
    ),
    (
        'repo',
        ARRAY['Read', 'Grep', 'Glob'],
        ARRAY['repository-investigation'],
        true,
        true,
        false,
        '{%- if skills %}Load and follow these skills before doing anything else: {{ skills | join(", ") }}. {% endif -%}Answer from this repository only.{%- if tools %} Use {{ tools | join(", ") }} to read the code before answering.{% endif %} Cite the file path and line for every factual claim about the code, and cite only files you read in this turn. Do not add claims that are not in the files you read. If the code doesn''t answer the question, say so and stop. Do not answer from memory.',
        'Blocked.{%- if tools %} Read the code with {{ tools | join(", ") }}, then answer{% else %} Answer{% endif %} only from what you read, citing file paths and lines from this turn.',
        'Intent: repo',
        NULL
    )
ON CONFLICT (name) DO UPDATE SET
    tools              = excluded.tools,
    skills             = excluded.skills,
    decision           = excluded.decision,
    proceed            = excluded.proceed,
    suppress_output    = excluded.suppress_output,
    additional_context = excluded.additional_context,
    reason             = excluded.reason,
    system_message     = excluded.system_message,
    stop_reason        = excluded.stop_reason;



UPDATE intent_enum SET
    tools              = NULL,
    skills             = NULL,
    decision           = true,
    proceed            = true,
    suppress_output    = false,
    additional_context = 'The evidence for this is outside your access. Do not investigate the system yourself. Ask the user to run exactly one command: give it in one code block, say what its output will tell you, then stop and wait for the output. Do not guess the result.',
    reason             = 'Blocked. Give exactly one command for the user to run, in one code block, say what its output will tell you, then stop.',
    system_message     = 'Intent: probe',
    stop_reason        = NULL
WHERE name = 'probe';

UPDATE intent_enum SET
    tools              = NULL,
    skills             = NULL,
    decision           = NULL,
    proceed            = true,
    suppress_output    = false,
    additional_context = 'Respond only to what was said. Do not use tools, and do not add information that was not asked for.',
    reason             = NULL,
    system_message     = 'Intent: conversation',
    stop_reason        = NULL
WHERE name = 'conversation';

UPDATE intent_enum SET
    tools              = NULL,
    skills             = NULL,
    decision           = NULL,
    proceed            = true,
    suppress_output    = false,
    additional_context = NULL,
    reason             = NULL,
    system_message     = 'Intent: unclassified',
    stop_reason        = NULL
WHERE name = 'unclassified';

INSERT INTO intent_enum
    (name, tools, skills, decision, proceed, suppress_output,
     additional_context, reason, system_message, stop_reason)
VALUES
    (
        'design',
        NULL,
        ARRAY['architecture-design'],
        NULL,
        true,
        false,
        '{%- if skills %}Load and follow these skills before doing anything else: {{ skills | join(", ") }}. {% endif -%}This is an architecture design discussion. Discuss before producing anything: ask questions, challenge assumptions, surface open decisions. Define components and their responsibilities only. Do not plan or implement. After presenting the architecture, stop.',
        NULL,
        'Intent: design',
        NULL
    ),
    (
        'plan',
        ARRAY['Read', 'Grep', 'Glob'],
        ARRAY['repository-plan-changes'],
        true,
        true,
        false,
        '{%- if skills %}Load and follow these skills before doing anything else: {{ skills | join(", ") }}. {% endif -%}Plan only.{%- if tools %} Read the relevant code with {{ tools | join(", ") }} before drafting the plan.{% endif %} Base every step on code you read in this turn and cite file paths. Do not edit files or implement.',
        'Blocked.{%- if tools %} Read the relevant code with {{ tools | join(", ") }} before presenting a plan.{% endif %}',
        'Intent: plan',
        NULL
    ),
    (
        'code',
        ARRAY['Edit', 'Write'],
        ARRAY['repository-coding'],
        true,
        true,
        false,
        '{%- if skills %}Load and follow these skills before doing anything else: {{ skills | join(", ") }}. {% endif -%}Implement only the change the user authorized.{%- if tools %} Make it with {{ tools | join(" or ") }}.{% endif %} Do not expand scope. Stop when the change is done.',
        'Blocked. You did not change any file.{%- if tools %} Make the authorized change with {{ tools | join(" or ") }}.{% endif %}',
        'Intent: code',
        NULL
    )
ON CONFLICT (name) DO UPDATE SET
    tools              = excluded.tools,
    skills             = excluded.skills,
    decision           = excluded.decision,
    proceed            = excluded.proceed,
    suppress_output    = excluded.suppress_output,
    additional_context = excluded.additional_context,
    reason             = excluded.reason,
    system_message     = excluded.system_message,
    stop_reason        = excluded.stop_reason;

