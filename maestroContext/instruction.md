---
name: maestro-mobile-testing
description: "Generate high-quality, industry-standard Maestro mobile test cases for Android & iOS (Maestro UI test generator + best practice enforcement)."
author: your-name-or-org-name
tags:
  - maestro
  - mobile-testing
  - qa
  - automation
  - android
  - ios
  - yaml
  - best-practices
---

# Maestro Mobile Testing Skill

## Overview

This skill provides AI agents with the capability to **generate robust, maintainable Maestro test flows (YAML)** for mobile applications (Android & iOS).  
It enforces testing best practices, reusable flows, validations, and CI readiness.

Use this skill to create:

* Smoke tests
* Regression test suites
* UI validation + navigation flows
* Input validation tests
* Edge-case + error-scenario tests
* Cross-platform Maestro flows

---

## Usage Instructions

When invoked, the AI agent should:

1. Ask for:
   * Target app (Android, iOS, or both)
   * Screen/feature description
   * Test types required (smoke, regression, negative, etc.)
   * Any specific flows (login, onboarding, forms, etc.)

2. Return:
   * Clean **Maestro YAML test code**
   * Well-commented structure
   * Metadata and tags
   * Suggested reusable subflows
   * Optional CI integration tips

---

## Quality Rules

Generated test cases MUST:

* Be valid Maestro YAML syntax
* Use `waitFor`, not hard sleeps
* Include assertions (`assertVisible`, `assertNotVisible`)
* Use accessibility IDs or test tags
* Have clear structure with comments
* Cover positive, negative, & edge cases
* Be modular and scalable

---

## Example Prompt

> “Generate Maestro tests for the login screen:  
> - Valid login  
> - Invalid password  
> - Empty fields validation  
> Target platform: Android & iOS”

Expected Output:

```yaml
appId: com.example.app
---
# Smoke test — Login
- launchApp
- clearState

# Login screen visible
- assertVisible: "Login Screen"

# Empty Fields
- tapOn:
    id: "login_button"
- assertVisible: "Error: Email required"

# Invalid Password
- tapOn: { id: "email_input" }
- inputText: "user@example.com"
- tapOn: { id: "password_input" }
- inputText: "wrongpass"
- tapOn: { id: "login_button" }
- assertVisible: "Error: Invalid credentials"

# Valid Login
- tapOn: { id: "email_input" }
- inputText: "user@example.com"
- tapOn: { id: "password_input" }
- inputText: "CorrectPass123"
- tapOn: { id: "login_button" }
- waitFor:
    visible: "Home Screen"
    timeout: 5000
- assertVisible: "Welcome"
