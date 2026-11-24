# Bagisto AI Workflow Design

## Goal

Add the same AI collaboration structure used in the reference app, but tailor it to this Bagisto Flutter repo and keep all AI-specific documentation under `aidocs/`.

## Decision

Use a Bagisto-specific layout with:

- root entry files for fast agent onboarding
- long-lived architecture docs in `aidocs/engineering/`
- AI design/plan history in `aidocs/superpowers/`
- graphify output in `graphify-out/`

## Why This Structure

`Docs/` already exists for human-facing product and setup material. Keeping AI workflow docs under `aidocs/` avoids mixing operating instructions for agents with install guides and screenshots.

This also keeps the repo easy to scan:

- root files answer "how should I work here?"
- `aidocs/engineering/` answers "how is the app structured?"
- `aidocs/superpowers/` answers "why was an AI-assisted change designed this way?"
- `graphify-out/` answers "what does the current code graph look like?"

## Planned File Layout

- `AGENTS.md`
- `CLAUDE.md`
- `agent.md`
- `plan.md`
- `aidocs/engineering/README.md`
- `aidocs/engineering/04-system-architecture.md`
- `aidocs/engineering/06-api-contracts.md`
- `aidocs/engineering/12-testing-strategy.md`
- `aidocs/engineering/13-ai-agent-workflow.md`
- `aidocs/superpowers/specs/`
- `aidocs/superpowers/plans/`
- `.graphifyignore`
- `graphify-out/README.md`
- generated `graphify-out/GRAPH_REPORT.md`
- generated `graphify-out/graph.json`

## Bagisto-Specific Content Requirements

The docs should describe the real app, not the Odoo printer app. They should cover:

- Flutter startup order in `main.dart`
- `GraphQLClientProvider` as the shared network entry point
- `ChannelBootstrapService` locale/currency bootstrap
- auth storage and `AuthBloc`
- guest cart token versus authenticated customer token behavior
- repository plus BLoC/Cubit feature boundaries
- `MainShell` tab navigation
- notification routing and FCM support
- existing unit/widget tests and Maestro flows

## Graphify Rules

- graphify should be treated as required navigation tooling for non-trivial codebase work
- the repo should ship with `.graphifyignore`
- generated graph output should live in `graphify-out/`
- cache and temp internals should stay ignored in git

## Out Of Scope

- copying Odoo-specific historical specs or plans
- changing Bagisto runtime behavior
- pinning unrelated external skills in `skills-lock.json`
