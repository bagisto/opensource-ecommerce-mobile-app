# Maestro Test Suite - Configuration & Setup Guide

## Quick Start

### 1. List Available Devices
```bash
xcrun simctl list devices | grep -i "iphone"
```

### 2. Get Device UDID  
```bash
# Create and boot simulator if needed
xcrun simctl create "iPhone 15" com.apple.CoreSimulator.CoreSimulatorService iPhone15

# Boot the simulator
open -a Simulator

# Get UDID
xcrun simctl list devices | grep iPhone
```

### 3. Install and Run App
```bash
cd /Users/jitendra/Documents/Demo_project/Bagisto_flutter

# Build app for simulator
flutter build ios --simulator

# Install on simulator
xcrun simctl install booted build/ios/iphonesimulator/Runner.app

# Or simply run
flutter run
```

### 4. Run Tests
```bash
# Update UDID with your device ID
DEVICE_ID="00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE"

# Run smoke test
maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID

# Run all tests
maestro test .maestro/flows/master_flow.yaml --udid $DEVICE_ID
```

---

## Test Configuration

### Update Test Credentials
Edit `.maestro/flows/auth_flow.yaml`:
```yaml
- inputText: "your-test-email@example.com"
- inputText: "your-test-password"
```

### Adjust Timeouts
If tests are timing out, increase sleep durations:
```yaml
- sleep:
    ms: 3000  # Increase from 2000 to 3000 or more
```

### Device-Specific Settings
For different devices, create separate configurations:
```bash
# iPhone 14
maestro test .maestro/flows/smoke_flow.yaml --udid <iphone14_udid>

# iPhone 15 Pro
maestro test .maestro/flows/smoke_flow.yaml --udid <iphone15_udid>
```

---

## Test Execution Patterns

### Pattern 1: Single Flow Test
```bash
maestro test .maestro/flows/auth_flow.yaml --udid $DEVICE_ID
```

### Pattern 2: Multiple Sequential Flows
```bash
maestro test \
  .maestro/flows/smoke_flow.yaml \
  .maestro/flows/auth_flow.yaml \
  .maestro/flows/home_flow.yaml \
  --udid $DEVICE_ID
```

### Pattern 3: Complete Master Suite
```bash
maestro test .maestro/flows/master_flow.yaml --udid $DEVICE_ID
```

### Pattern 4: With Timeout
```bash
maestro test .maestro/flows/smoke_flow.yaml \
  --udid $DEVICE_ID \
  --timeout 300  # 5 minutes
```

### Pattern 5: Continue on Failure
```bash
maestro test .maestro/flows/smoke_flow.yaml \
  --udid $DEVICE_ID \
  --continue-on-failure
```

---

## Advanced Selectors

### Text Matching
```yaml
# Exact match
- tapOn:
    text: "Login"

# Regex match
- tapOn:
    text: "Login|Sign In"
    isRegex: true

# Case insensitive (default)
- assertVisible:
    text: "login"  # Matches "Login", "LOGIN", "login"
```

### Type Matching
```yaml
# By UI element type
- tapOn:
    type: "TextField"
    index: 0  # First TextField

- tapOn:
    type: "Button"
    index: 1  # Second Button

# Common types: TextField, Button, Card, Container, Image, Icon, Text, ListView
```

### Index Matching
```yaml
# When multiple elements match
- tapOn:
    text: "Add"
    index: 0  # First occurrence

- tapOn:
    text: "Add"
    index: 1  # Second occurrence
```

### Combined Selectors
```yaml
# Multiple conditions
- tapOn:
    text: "Login"
    type: "Button"
    index: 0
```

---

## Common Test Patterns

### Pattern: Form Filling
```yaml
# Fill email
- tapOn:
    type: "TextField"
    index: 0
- inputText: "user@example.com"

# Fill password
- tapOn:
    type: "TextField"
    index: 1
- inputText: "password"

# Submit
- tapOn:
    text: "Submit"
```

### Pattern: List Navigation
```yaml
# Tap item in list
- tapOn:
    type: "Card"
    index: 0

# Wait for page load
- sleep:
    ms: 1500

# Assert content loaded
- assertVisible:
    text: "Details"
```

### Pattern: Scroll to Element
```yaml
# Scroll down until element visible
- scroll:
    down: 3

- sleep:
    ms: 500

- assertVisible:
    text: "Element"

# If not found, scroll more
- scroll:
    down: 3
```

### Pattern: Back Navigation
```yaml
# Tap back button (first icon match)
- tapOn:
    type: "Icon"
    index: 0

# Wait for navigation
- sleep:
    ms: 1000

# Verify page loaded
- assertVisible:
    text: "Previous Page"
```

### Pattern: Element Visibility with Wait
```yaml
# Wait for element (up to timeout)
- waitFor:
    text: "Data Loaded"
    timeout: 5000

# Assert after wait
- assertVisible:
    text: "Data Loaded"
```

---

## Assertion Best Practices

### 1. Use Descriptive Assertions
```yaml
# Good ✓
- comment: "Verify login success message"
- assertVisible:
    text: "Welcome back!"

# Could be better
- comment: "Check for text"
- assertVisible:
    text: "Welcome"
```

### 2. Strategic Placement
```yaml
# After every navigation
- tapOn:
    text: "Next"
- sleep:
    ms: 1500
- assertVisible:
    text: "New Page Title"
```

### 3. Multiple Assertions
```yaml
# Verify multiple elements on same page
- assertVisible:
    text: "Product Name"

- assertVisible:
    text: "Price"

- assertVisible:
    text: "Add to Cart"
```

### 4. Regex for Flexibility
```yaml
# Handle dynamic/variable content
- assertVisible:
    text: "Order #[0-9]+"
    isRegex: true

# Handle multiple possible texts
- assertVisible:
    text: "error|Error|ERROR"
    isRegex: true
```

---

## Debugging Failed Tests

### 1. Check Device Log
```bash
# iOS device log
xcrun simctl spawn booted log stream --level debug
```

### 2. Add Debug Comments
```yaml
- comment: "DEBUG: Before login"
- sleep:
    ms: 1000
- comment: "DEBUG: After sleep"
```

### 3. Increase Verbosity
```bash
maestro test flows/auth_flow.yaml \
  --udid $DEVICE_ID \
  -v  # Verbose output
```

### 4. Step Through Manually
```bash
# Stop test at specific point
- comment: "STOP HERE FOR MANUAL INSPECTION"
- sleep:
    ms: 30000  # Wait 30 seconds
```

### 5. Screenshot Capture
Tests automatically capture screenshots, check:
- `.maestro_artifacts/` directory
- Latest failure screenshot

---

## Performance Tips

### Optimize Timeouts
```yaml
# Fast network
- sleep:
    ms: 1000

# Slow network
- sleep:
    ms: 3000

# Very slow network
- sleep:
    ms: 5000
```

### Reduce Test Count
```bash
# Run minimal smoke tests only
maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID
```

### Parallel Execution
```bash
# Run different flows in parallel (requires multiple devices)
maestro test .maestro/flows/auth_flow.yaml --udid $DEVICE_ID_1 &
maestro test .maestro/flows/product_flow.yaml --udid $DEVICE_ID_2 &
wait
```

### Cache Warming
```bash
# Pre-load data
flutter run --profile
# Let app settle
sleep 10
# Then run tests
maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID
```

---

## Maintenance Tasks

### Weekly
- Review test results
- Check for new failures
- Update selectors if UI changed

### Monthly
- Review test coverage
- Add tests for new features
- Remove tests for deprecated features
- Update documentation

### Per Release
- Test new functionality
- Update version numbers
- Add release notes
- Test on latest iOS version

---

## CI/CD Integration Examples

### GitHub Actions
```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  maestro-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - run: brew install maestro
      
      - run: flutter pub get
      
      - run: flutter build ios --simulator
      
      - run: |
          DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | tail -1 | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/')
          maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID
```

### GitLab CI
```yaml
e2e_tests:
  image: macos-latest
  script:
    - brew install maestro
    - flutter pub get
    - flutter build ios --simulator
    - maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_ID
  artifacts:
    paths:
      - .maestro_artifacts/
```

### Jenkins
```groovy
pipeline {
    agent {
        label 'macos'
    }
    stages {
        stage('Build') {
            steps {
                sh 'flutter pub get && flutter build ios --simulator'
            }
        }
        stage('Test') {
            steps {
                sh 'maestro test .maestro/flows/smoke_flow.yaml --udid $DEVICE_UDID'
            }
        }
    }
}
```

---

## Troubleshooting Checklist

- [ ] Device is booted and ready
- [ ] App is installed on device
- [ ] Network is stable
- [ ] Credentials are correct
- [ ] UDID is correct
- [ ] Maestro is installed latest version
- [ ] Xcode is up to date
- [ ] Simulator is not locked
- [ ] Test data exists (for order tests)
- [ ] API endpoint is accessible

---

## Additional Resources

- Maestro CLI: `maestro --help`
- Device Logs: XCode → Window → Devices and Simulator
- Simulator Menu: Xcode → Open Developer Tool → Simulator
- Test Results: `.maestro_artifacts/` after each run

---

**Version**: 1.0  
**Last Updated**: February 2026  
**Maestro Version**: 1.35.0+  
**Flutter Version**: 3.0+

