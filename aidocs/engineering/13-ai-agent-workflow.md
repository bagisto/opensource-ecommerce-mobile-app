# AI Agent Workflow

## Goal

Give agents one repeatable workflow for this Bagisto repo.

## Required Order

1. Read `plan.md`
2. Read `AGENTS.md`
3. Read `graphify-out/GRAPH_REPORT.md`
4. Read `agent.md`
5. Read relevant engineering docs
6. Inspect code before changing behavior
7. Implement the smallest safe change
8. Add or update tests if logic changed
9. Run analyze, test, or relevant flow checks for touched scope
10. Run `graphify update .` after code changes
11. Update docs when source-of-truth behavior changed

## Graphify Workflow

Graphify is required for this repo.

1. read `graphify-out/GRAPH_REPORT.md` before raw file search
2. use graph clusters, god nodes, and bridge nodes to find central files
3. avoid blind repo-wide searching first
4. use `graphify update .` after code changes to refresh AST graph output
5. use `/graphify .` from a graphify-aware agent for doc-heavy semantic refreshes
6. treat graphify as the first navigation layer, not an optional extra

Current state:

- graphify CLI is installed and available in shell
- repo remains graphify-ready via `.graphifyignore`
- current graph output is maintained in `graphify-out/`

## Caveman Workflow

If the user asks for caveman mode:

- respond terse
- keep technical meaning exact
- no fluff
- stop only when the user asks for normal mode

## Documentation Update Rule

Update docs when any of these change:

- endpoint configuration source of truth
- request header behavior
- token or persistence model
- main architecture boundary
- testing command or verification story
- graphify workflow expectations

## Do Not

- do not guess Bagisto API behavior from UI assumptions alone
- do not build one-off GraphQL clients inside random features
- do not blur guest-cart and authenticated token semantics
- do not treat docs as optional after architecture changes
