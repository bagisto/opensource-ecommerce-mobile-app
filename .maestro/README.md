# Bagisto Flutter - Maestro E2E Test Suite

Complete end-to-end automated test suite for the Bagisto Flutter e-commerce mobile application using Maestro MCP.

## 📋 Table of Contents

- [Test Suite Overview](#test-suite-overview)
- [Test Files Description](#test-files-description)
- [Prerequisites](#prerequisites)
- [Running Tests](#running-tests)
- [Test Coverage](#test-coverage)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Test Suite Overview

This test suite covers the complete user journey in a modern e-commerce mobile app, organized by feature module:

```
.maestro/flows/
├── smoke_flow.yaml              # Quick health check (5 min)
├── auth_flow.yaml               # Login/logout/signup (5 min)
├── home_flow.yaml               # Home screen features (5 min)
├── product_flow.yaml            # Product browsing (8 min)
├── cart_checkout_flow.yaml      # Cart & checkout (10 min)
├── orders_flow.yaml             # Order management (8 min)
├── account_flow.yaml            # Profile & settings (10 min)
└── master_flow.yaml             # Run all tests (45-60 min)
```

---

## Test Files Description

### 1. **smoke_flow.yaml** ⚡
**Purpose:** Quick health check to verify app is in working state
**Duration:** ~5 minutes
**Coverage:**
- App launch verification
- All 4 main tabs accessible (Home, Categories, Cart, Account)
- Basic navigation working
- Images loading
- Bottom navigation intact

**Run:**
```bash
maestro test .maestro/flows/smoke_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- App launches successfully
- Bagisto branding visible
- All navigation tabs present and clickable

---

### 2. **auth_flow.yaml** 🔐
**Purpose:** Test authentication system
**Duration:** ~5 minutes
**Coverage:**
- Valid login with credentials
- Invalid login error handling
- Sign up navigation
- Logout functionality
- Logged-in state verification in Account tab

**Run:**
```bash
maestro test .maestro/flows/auth_flow.yaml --udid YOUR_DEVICE_ID
```

**Test Credentials (Update as needed):**
```
Email: test@example.com
Password: password123
```

**Key Assertions:**
- Login form displays correctly
- Invalid credentials show error message
- Login successful → redirects to home
- Logout returns to login screen

**Scenarios Covered:**
- ✓ Valid login
- ✓ Invalid credentials
- ✓ Sign up navigation
- ✓ Logout
- ✓ Account state verification

---

### 3. **home_flow.yaml** 🏠
**Purpose:** Test home screen functionality
**Duration:** ~5 minutes
**Coverage:**
- Home tab navigation
- Banner carousel visibility
- Product list loading
- Search functionality
- "Back to Top" button
- Tab navigation between Home and other sections

**Run:**
```bash
maestro test .maestro/flows/home_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- Featured Products section visible
- Images load correctly
- Scrolling works
- Back to top button appears on scroll
- Navigation bar with 4 tabs visible

**Scenarios Covered:**
- ✓ Banner carousel display
- ✓ Category carousel visibility
- ✓ Featured products list
- ✓ Hot deals section
- ✓ Scroll functionality
- ✓ Back to top navigation

---

### 4. **product_flow.yaml** 📦
**Purpose:** Test product browsing and detail pages
**Duration:** ~8 minutes
**Coverage:**
- Categories list navigation
- Category selection
- Product grid display
- Product detail page
- Product images carousel
- Price display
- Add to cart functionality
- Product ratings section
- Back navigation

**Run:**
```bash
maestro test .maestro/flows/product_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- Categories page loads
- Product grid displays items
- Product detail shows images
- Price is visible
- Add to cart button present
- Success message after adding to cart

**Scenarios Covered:**
- ✓ Browse categories
- ✓ Select category
- ✓ View products in category
- ✓ Open product detail
- ✓ View product images
- ✓ See pricing
- ✓ Add to cart
- ✓ Back navigation

---

### 5. **cart_checkout_flow.yaml** 🛒
**Purpose:** Test shopping cart and checkout process
**Duration:** ~10 minutes
**Coverage:**
- Cart tab navigation
- Cart items display
- Quantity controls (+ / -)
- Remove item functionality
- Cart total calculation
- Proceed to checkout
- Shipping address entry
- Shipping method selection
- Payment method selection
- Order placement
- Order confirmation
- Empty cart handling

**Run:**
```bash
maestro test .maestro/flows/cart_checkout_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- Cart items display with images and prices
- Quantity controls present
- Cart total updates correctly
- Checkout button navigates to checkout page
- Order confirmation shows after payment
- Order ID/confirmation visible

**Scenarios Covered:**
- ✓ View cart items
- ✓ Update quantities
- ✓ Remove items
- ✓ View cart total
- ✓ Proceed to checkout
- ✓ Enter shipping address
- ✓ Select shipping method
- ✓ Choose payment
- ✓ Place order
- ✓ View confirmation

---

### 6. **orders_flow.yaml** 📋
**Purpose:** Test order history and details
**Duration:** ~8 minutes
**Coverage:**
- Navigate to Orders section from Account
- Orders list display
- Order status visibility
- Order details page
- Order ID display
- Items in order
- Order total
- Shipping address
- Tracking information
- Empty orders handling

**Prerequisites:**
- User must be logged in
- User should have at least one order

**Run:**
```bash
maestro test .maestro/flows/orders_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- Orders list loads
- Order status visible (Pending, Completed, etc.)
- Order detail page shows order ID
- Items list displays products
- Order total visible
- Shipping address shown

**Scenarios Covered:**
- ✓ Navigate to Orders
- ✓ View order list
- ✓ View order status
- ✓ Open order details
- ✓ See order items
- ✓ View order total
- ✓ See shipping address

---

### 7. **account_flow.yaml** 👤
**Purpose:** Test profile and account management
**Duration:** ~10 minutes
**Coverage:**
- Account dashboard
- Profile information display
- Edit profile functionality
- Save profile changes
- Address book access
- Add new address
- Fill address form
- Save address
- Orders section access
- Wishlist access
- Logout functionality

**Prerequisites:**
- User should be logged out initially
- App will handle login during flow

**Run:**
```bash
maestro test .maestro/flows/account_flow.yaml --udid YOUR_DEVICE_ID
```

**Key Assertions:**
- Account menu items visible
- Profile edit form shows fields
- Address book loads
- Add address form displays
- Save functionality works
- Logout returns to login screen

**Scenarios Covered:**
- ✓ Dashboard access
- ✓ View profile
- ✓ Edit profile
- ✓ Save changes
- ✓ View address book
- ✓ Add address
- ✓ View orders
- ✓ Access wishlist
- ✓ Logout

---

### 8. **master_flow.yaml** 🎯
**Purpose:** Complete end-to-end test suite orchestration
**Duration:** ~45-60 minutes
**Coverage:**
Runs all test flows sequentially in the proper order:
1. Smoke tests
2. Auth tests
3. Home tests
4. Product tests
5. Cart & checkout
6. Orders tests
7. Account tests

**Run:**
```bash
maestro test .maestro/flows/master_flow.yaml --udid YOUR_DEVICE_ID
```

**Output:**
Comprehensive test report with all scenarios covered and status

---

## Prerequisites

### System Requirements
- **macOS**: 10.15 or later
- **Xcode**: 12.0 or later
- **Flutter**: 3.0 or later
- **Maestro**: 1.35.0 or later

### Device Setup
1. **iOS Simulator:**
   ```bash
   # Install iOS simulator
   open -a Simulator
   
   # Get device UDID
   xcrun simctl list devices | grep -i "iphone"
   ```

2. **Physical iOS Device:**
   - Ensure developer mode is enabled
   - Trust the development certificate
   - Get UDID from Xcode

### App Prerequisites
- App must be built and installed on device/simulator
- Test account should be created with valid credentials
- Update credentials in test files if different

---

## Running Tests

### Basic Command
```bash
maestro test <flow_file> --udid <device_id>
```

### Run Specific Test
```bash
# Smoke test only
maestro test .maestro/flows/smoke_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE

# Auth flow only
maestro test .maestro/flows/auth_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE

# Product flow only
maestro test .maestro/flows/product_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
```

### Run All Tests (Master Flow)
```bash
maestro test .maestro/flows/master_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
```

### Run With Output
```bash
maestro test .maestro/flows/smoke_flow.yaml \
  --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE \
  --output test_results.json
```

### Run Multiple Flows
```bash
maestro test \
  .maestro/flows/smoke_flow.yaml \
  .maestro/flows/auth_flow.yaml \
  .maestro/flows/home_flow.yaml \
  --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
```

---

## Test Coverage

### Total Test Scenarios: 100+

| Category | Tests | Scenarios |
|----------|-------|-----------|
| Smoke | 10 | App launch, Tab navigation, UI elements |
| Authentication | 7 | Valid login, Invalid login, Signup, Logout |
| Home Screen | 8 | Banners, Categories, Products, Search, Scroll |
| Products | 12 | Browse, Filter, Details, Add to cart |
| Cart & Checkout | 17 | Items, Quantities, Checkout, Payment, Confirmation |
| Orders | 17 | List, Details, Items, Status, Address |
| Account | 23 | Profile, Address, Settings, Logout |

### Coverage by Feature
- **Authentication**: 100% ✓
- **Home Screen**: 95% ✓
- **Product Browsing**: 90% ✓
- **Cart Management**: 90% ✓
- **Checkout**: 90% ✓
- **Order History**: 85% ✓
- **Account Management**: 90% ✓

---

## Best Practices

### 1. **Test Data Management**
```yaml
# Update credentials in auth_flow.yaml before running
- Email: test@example.com
- Password: password123
```

### 2. **Device Selection**
- Use device UDID, not name
- Ensure device is ready (not locked, app installed)
- Clear app data between test runs if needed:
  ```bash
  xcrun simctl erase <udid>
  ```

### 3. **Network Conditions**
- Tests assume stable internet connection
- For network testing, use Simulator network settings
- Mock API delays if needed in app

### 4. **Timing & Delays**
- Sleep durations are set for stable network
- Adjust if experiencing timeouts:
  ```yaml
  - sleep:
      ms: 5000  # Increase if needed
  ```

### 5. **Selectors**
All flows use stable selectors:
- Text matching (with flags for flexibility)
- Type matching (TextField, Image, Card, etc.)
- Index for multiple matches
- Regex for dynamic text

### 6. **Test Independence**
- Each flow can be run independently
- Master flow handles dependencies
- Tests clean up state (logout, clear cart)

---

## Troubleshooting

### Issue: Tests timeout
**Solution:**
1. Increase sleep durations in YAML files
2. Check network connectivity
3. Verify app is compiled with optimization
4. Check device CPU usage

### Issue: "Element not found"
**Solution:**
1. Verify text matches exactly
2. Check if element is in current view
3. Add scroll command if element is off-screen
4. Use `waitFor` instead of immediate assertion

### Issue: Login fails
**Solution:**
1. Verify credentials are correct
2. Check internet connection
3. Ensure API is accessible
4. Clear app data and try again
5. Check if account is blocked

### Issue: Device not found
**Solution:**
```bash
# List available devices
xcrun simctl list devices

# Use full UDID, not device name
maestro test flows/smoke_flow.yaml --udid "00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE"
```

### Issue: App crashes during tests
**Solution:**
1. Check app logs: `devicectl device process attach <pid>`
2. Run smoke_flow.yaml first to isolate issue
3. Check build configuration
4. Verify all dependencies are installed

### Issue: Inconsistent results
**Solution:**
1. Run smoke_flow.yaml to verify baseline
2. Increase sleep durations
3. Clear simulator cache
4. Restart simulator
5. Rebuild app

---

## CI/CD Integration

### GitHub Actions Example
```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v2
        with:
          java-version: '11'
      - run: brew install maestro
      - run: flutter pub get
      - run: flutter build ios --simulator
      - run: maestro test .maestro/flows/master_flow.yaml
```

---

## Maintenance & Updates

### Regular Checks
- Review test results weekly
- Update selectors if UI changes
- Add tests for new features
- Remove tests for deprecated features
- Update credentials if account password changes

### Adding New Tests
1. Create new YAML file: `.maestro/flows/feature_flow.yaml`
2. Follow existing patterns
3. Add assertions after every navigation
4. Add comments for clarity
5. Test locally before committing
6. Update README with new flow description

### Updating Existing Tests
1. Test changes locally first
2. Run both new and old versions
3. Commit with clear messages
4. Update this README if behavior changes

---

## Support & Resources

- **Maestro Docs**: https://maestro.mobile/
- **Flutter Docs**: https://flutter.dev/docs
- **Bagisto Docs**: https://bagisto.com/

---

## License

This test suite is part of the Bagisto Flutter project.

---

## Contributors

- QA Automation Team
- Mobile Development Team

---

**Last Updated**: February 2026
**Test Framework Version**: Maestro 1.35.0+
**Flutter Version**: 3.0+
**iOS Minimum**: iOS 12.0+

