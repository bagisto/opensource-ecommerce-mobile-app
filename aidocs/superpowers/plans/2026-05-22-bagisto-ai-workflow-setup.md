# Bagisto AI Workflow Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Bagisto-specific AI onboarding docs, `aidocs/**` architecture memory, and graphify scaffolding/output for this repo.

**Architecture:** Keep agent entry files at the repo root for fast discovery, place all AI-only documentation under `aidocs/`, and maintain a root `graphify-out/` directory for graph-guided codebase navigation.

**Tech Stack:** Markdown, graphify CLI, Flutter repo conventions

---

### Task 1: Root AI Entry Files

**Files:**
- Create: `AGENTS.md`
- Create: `CLAUDE.md`
- Create: `agent.md`
- Create: `plan.md`

- [ ] **Step 1: Create the root entry files**

Write root docs that explain the repo objective, reading order, runtime rules, and graphify expectations for this Bagisto app.

- [ ] **Step 2: Make the content Bagisto-specific**

Document the real Flutter structure, GraphQL client factory, token handling, and main feature boundaries instead of copying Odoo-specific printer language.

- [ ] **Step 3: Verify the reading order**

Confirm each root file points to `aidocs/engineering/**` and `graphify-out/**` rather than `docs/engineering/**`.

### Task 2: Engineering Docs

**Files:**
- Create: `aidocs/engineering/README.md`
- Create: `aidocs/engineering/04-system-architecture.md`
- Create: `aidocs/engineering/06-api-contracts.md`
- Create: `aidocs/engineering/12-testing-strategy.md`
- Create: `aidocs/engineering/13-ai-agent-workflow.md`

- [ ] **Step 1: Create the engineering docs folder**

Add `aidocs/engineering/` and keep it focused on stable architecture memory rather than one-off task notes.

- [ ] **Step 2: Document the architecture**

Describe startup order, shared core services, feature boundaries, navigation, persistence, and notification behavior.

- [ ] **Step 3: Document API and testing rules**

Capture header behavior, token semantics, client construction rules, and the expected verification layers for Dart and Maestro work.

### Task 3: AI Design And Plan History

**Files:**
- Create: `aidocs/superpowers/specs/2026-05-22-bagisto-ai-workflow-design.md`
- Create: `aidocs/superpowers/plans/2026-05-22-bagisto-ai-workflow-setup.md`

- [ ] **Step 1: Save the approved design**

Write the chosen `aidocs/**` structure and Bagisto-specific scope into a dated design spec.

- [ ] **Step 2: Save the implementation plan**

Record the scaffold and graphify tasks so future sessions can understand how the AI workflow layer was introduced.

### Task 4: Graphify Scaffolding

**Files:**
- Create: `.graphifyignore`
- Modify: `.gitignore`
- Create: `graphify-out/README.md`

- [ ] **Step 1: Add graphify ignore rules**

Ignore generated folders, caches, image-heavy docs, and graphify self-output so the graph stays focused on meaningful source files.

- [ ] **Step 2: Ignore graphify internals in git**

Keep committed output limited to stable artifacts such as `GRAPH_REPORT.md`, `graph.json`, and optional wiki files.

- [ ] **Step 3: Document the output folder**

Add a short README explaining what `graphify-out/` stores and when to refresh it.

### Task 5: Generate And Verify Graph Output

**Files:**
- Generate: `graphify-out/GRAPH_REPORT.md`
- Generate: `graphify-out/graph.json`

- [ ] **Step 1: Run graphify**

Run: `graphify update .`

Expected: graphify completes successfully and writes fresh output into `graphify-out/`.

- [ ] **Step 2: Sanity-check the generated report**

Open `graphify-out/GRAPH_REPORT.md` and confirm the graph reflects this Bagisto repo rather than the Odoo reference project.

- [ ] **Step 3: Sanity-check git status**

Run: `git status --short`

Expected: new AI docs, graphify config, and graph outputs appear without unrelated destructive changes.
