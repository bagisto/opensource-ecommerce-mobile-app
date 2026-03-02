# Maestro Test Suite - FAQ & Best Practices

## Frequently Asked Questions

### Q1: How do I run tests on a physical device?
**A:** Use the device's UDID from Xcode:
```bash
# Get UDID in Xcode
# Xcode → Window → Devices and Simulators → Select device
# UDID appears in the identifier field

maestro test .maestro/flows/smoke_flow.yaml --udid "YOUR_DEVICE_UDID"
```

### Q2: Tests are timing out. How do I fix this?
**A:** Increase sleep/timeout values:
```yaml
# In YAML files, increase sleep durations
- sleep:
    ms: 5000  # Increased from 2000

# Or use waitFor with longer timeout
- waitFor:
    text: "Element"
    timeout: 10000  # 10 seconds
```

**Also check:**
- Network connectivity
- Device CPU usage
- API server response time
- Build optimization settings

### Q3: "Element not found" error - what should I do?
**A:** Debug the issue:
```bash
# 1. Check if element text is exact
# 2. Use regex for dynamic content
- assertVisible:
    text: "Order #[0-9]+"
    isRegex: true

# 3. Scroll to element first
- scroll:
    down: 3
- assertVisible:
    text: "Element"

# 4. Use waitFor instead of tapOn
- waitFor:
    text: "Element"
    timeout: 5000
- tapOn:
    text: "Element"
```

### Q4: How do I test with different app states (logged in/out)?
**A:** Use master_flow.yaml which handles state transitions:
- auth_flow.yaml (handles login)
- product_flow.yaml (uses logged-in state)
- account_flow.yaml (includes logout)

Or manually manage state:
```yaml
# Start logged out
- assertVisible:
    text: "Login"

# Login
- tapOn:
    text: "Login"
# ... auth flow ...

# Now in logged-in state
- assertVisible:
    text: "My Account"
```

### Q5: Can I run multiple tests in parallel?
**A:** Yes, with multiple devices:
```bash
# Terminal 1
maestro test .maestro/flows/auth_flow.yaml --udid DEVICE_1 &

# Terminal 2
maestro test .maestro/flows/product_flow.yaml --udid DEVICE_2 &

# Wait for both
wait
```

**Note:** Not recommended for single device (will conflict).

### Q6: How do I debug failing tests?
**A:** Use several approaches:
```bash
# 1. Run with verbose output
maestro test flow.yaml --udid $DEVICE_ID -v

# 2. Check artifacts
ls -la .maestro_artifacts/

# 3. Add debug sleeps
- comment: "DEBUG: Check state"
- sleep:
    ms: 30000  # 30 second pause for inspection

# 4. Take screenshot manually
xcrun simctl io booted screenshot
```

### Q7: How do I update test credentials?
**A:** Edit auth_flow.yaml:
```yaml
# auth_flow.yaml - Line ~62
- tapOn:
    type: "TextField"
    index: 0
- inputText: "your-new-email@example.com"

# Line ~67
- tapOn:
    type: "TextField"
    index: 1
- inputText: "your-new-password"
```

### Q8: Tests pass locally but fail in CI/CD. Why?
**A:** Common causes:
1. Different network latency - increase timeouts
2. Test data differences - use same test account
3. Time zone issues - ensure consistent date/time
4. Device state - clear app before tests
5. API endpoints - verify in CI environment

**Solution:**
```yaml
# Increase timeouts for CI
- sleep:
    ms: 5000  # Use higher values in CI

# Use environment variables
# In CI before running:
export TEST_EMAIL="ci-test@example.com"
export TEST_PASSWORD="ci-password"
```

### Q9: How do I add a new test flow?
**A:** 
1. Create new file: `.maestro/flows/feature_name_flow.yaml`
2. Follow template:
```yaml
appId: com.example.bagisto_flutter
---
# Test description
- launchApp
- sleep:
    ms: 2000
- assertVisible:
    text: "Screen1"

# ... test steps ...

# Always test locally first!
```
3. Test locally
4. Add to master_flow.yaml if needed
5. Update README.md

### Q10: Can I test with mocked API responses?
**A:** Yes, use app-level mocking:
1. Build app with mock flag (if supported)
2. Or use network proxy to mock responses
3. Or test with actual test API environment

**Maestro cannot directly mock APIs** - that's app responsibility.

---

## Best Practices

### 1. **Selector Strategy**
✅ **Good:**
```yaml
# Specific and stable
- tapOn:
    text: "Add to Cart"
    type: "Button"

# With regex for flexibility
- assertVisible:
    text: "Order #[0-9]+"
    isRegex: true
```

❌ **Avoid:**
```yaml
# Too specific to layout
- tapOn:
    type: "Button"
    index: 5

# Too generic
- tapOn:
    type: "Container"
```

### 2. **Assertion Placement**
✅ **Good:**
```yaml
- tapOn:
    text: "Next"
- sleep:
    ms: 1500
- assertVisible:
    text: "New Page"  # Immediate assertion
- scroll  # Then interact
```

❌ **Avoid:**
```yaml
- tapOn:
    text: "Next"
- scroll  # Don't interact before verification
- scroll
- sleep:
    ms: 5000
- assertVisible:  # Too late
    text: "New Page"
```

### 3. **Sleep Duration Strategy**
```yaml
# Fast actions (local)
- sleep:
    ms: 500

# Network operations
- sleep:
    ms: 1500

# Heavy operations (checkout, etc.)
- sleep:
    ms: 2500

# Slow networks/CI environments
- sleep:
    ms: 5000
```

### 4. **Testing Data Consistency**
✅ **Good practice:**
```yaml
# Use predictable test account
- email: "test@example.com"
- password: "testpass123"

# Use same test data across flows
# Keep test account active
```

❌ **Avoid:**
```yaml
# Dynamic/random test data
- email: "user${timestamp}@example.com"

# Deleting test data between runs
# Different credentials per flow
```

### 5. **Error Message Structure**
✅ **Good error handling:**
```yaml
- comment: "Test: Invalid login error message"
- tapOn:
    text: "Login"
# ... enter wrong credentials ...
- tapOn:
    text: "Login"
- sleep:
    ms: 2000

# Check for error (multi-option)
- assertVisible:
    text: "error|failed|incorrect|invalid"
    isRegex: true
```

### 6. **Test Independence**
✅ **Good:**
```yaml
# Each test can run standalone
# auth_flow can run without others
# product_flow works independently

# But master_flow orchestrates dependencies
# auth → product → cart → checkout
```

❌ **Avoid:**
```yaml
# Tests depending on others
# product_flow requiring auth_flow to run first
# Hardcoded assumptions about previous state
```

### 7. **Comment Best Practices**
✅ **Good:**
```yaml
# Clear section headers
- comment: "═══════════════════════════════════"
- comment: "SECTION: Payment Information"
- comment: "═══════════════════════════════════"

# Before complex operations
- comment: "Test: Fill shipping address with multiple fields"

# After assertions
- comment: "✓ Cart total verified"
```

### 8. **Timeout Handling**
✅ **Good:**
```yaml
# Use explicit waits for uncertain operations
- waitFor:
    text: "Loaded"
    timeout: 5000

# Fallback to scroll if waitFor fails
- scroll:
    down: 3
```

### 9. **Navigation Patterns**
✅ **Good pattern for deep navigation:**
```yaml
# Home → Category → Product → Cart
- tapOn:
    text: "Categories"
- sleep:
    ms: 1500
- tapOn:
    type: "Card"
    index: 0
- sleep:
    ms: 1500
- tapOn:
    type: "Card"
    index: 0
- sleep:
    ms: 1500

# Back through each layer
- tapOn:
    type: "Icon"  # Back button
    index: 0
- sleep:
    ms: 1000

- tapOn:
    type: "Icon"
    index: 0
- sleep:
    ms: 1000
```

### 10. **CI/CD Integration**
✅ **Good CI setup:**
```yaml
# .github/workflows/e2e.yml
- uses: actions/setup-java@v2
- run: brew install maestro
- run: flutter build ios --simulator
- run: |
    DEVICE_ID=$(xcrun simctl list devices | grep available | head -1 | awk '{print $(NF-1)}' | tr -d '()')
    maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID
- uses: actions/upload-artifact@v2
  if: always()
  with:
    name: maestro-artifacts
    path: .maestro_artifacts/
```

---

## Advanced Techniques

### Conditional Testing
```yaml
# Check if element exists (doesn't fail if missing)
- tapOn:
    text: "Optional Button"
# Continues even if button not found

# But assert when element should be there
- assertVisible:
    text: "Required Text"
# Fails if not found
```

### Dynamic Waits
```yaml
# Wait for multiple possible outcomes
- waitFor:
    text: "Success|Error|Timeout"
    isRegex: true
    timeout: 5000
```

### Index Management
```yaml
# When unsure about index
- tapOn:
    text: "Add"
    index: 0  # First occurrence

# If first doesn't work, try next
- tapOn:
    text: "Add"
    index: 1  # Second occurrence
```

### Screenshot-Driven Debugging
```bash
# After test failure, check screenshot
open .maestro_artifacts/

# Screenshots show exact state when assertion failed
# Use to identify selector issues
```

### Performance Profiling
```yaml
# In test file, add timing markers
- comment: "START: Login Flow"
# ... login steps ...
- comment: "END: Login Flow"
# ... continue ...

# Later analyze timing in results
```

---

## Common Mistakes & Solutions

| Mistake | Solution |
|---------|----------|
| Not waiting for navigation | Add `sleep: {ms: 1500}` after navigation |
| Selector too generic | Add type or index specification |
| Test assumes logged-in | Include login/logout in same flow |
| Not scrolling to element | Use `scroll` before `tapOn` if off-screen |
| Hardcoded delays | Use `waitFor` instead |
| No error message check | Always assert after action |
| Running without device | Use `./run_tests.sh list` first |
| Outdated selectors | Update when UI changes |
| No CI timeout handling | Increase timeouts in CI config |
| Test data issues | Use same test account consistently |

---

## Performance Metrics

Typical run times:
- **smoke_flow.yaml**: 5 min
- **auth_flow.yaml**: 5 min
- **home_flow.yaml**: 5 min
- **product_flow.yaml**: 8 min
- **cart_checkout_flow.yaml**: 10 min
- **orders_flow.yaml**: 8 min
- **account_flow.yaml**: 10 min
- **master_flow.yaml**: 45-60 min

**Optimization tips:**
- Run smoke tests for quick checks
- Run specific flows for feature testing
- Use master_flow only for final validation
- Parallel runs (multiple devices) reduce total time

---

## Support & Contact

- **Issues**: Check `.maestro_artifacts/` for screenshots
- **Documentation**: See README.md and CONFIGURATION.md
- **Community**: Maestro Discord/Community forums
- **Team**: Contact QA Automation team

---

**Version**: 1.0  
**Last Updated**: February 2026  

