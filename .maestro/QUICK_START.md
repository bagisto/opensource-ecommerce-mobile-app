# Quick Start Guide - Maestro Test Suite

## 📦 What Was Created

Complete end-to-end test automation suite for your Bagisto Flutter app:

```
.maestro/
├── flows/                           # All test flows
│   ├── smoke_flow.yaml              # 5 min - Quick health check
│   ├── auth_flow.yaml               # 5 min - Login/logout/signup
│   ├── home_flow.yaml               # 5 min - Home screen features
│   ├── product_flow.yaml            # 8 min - Product browsing
│   ├── cart_checkout_flow.yaml      # 10 min - Cart & checkout
│   ├── orders_flow.yaml             # 8 min - Order management
│   ├── account_flow.yaml            # 10 min - Profile & settings
│   └── master_flow.yaml             # 50 min - Complete E2E suite
├── run_tests.sh                     # Test runner script
├── README.md                        # Complete documentation
├── CONFIGURATION.md                 # Setup guide
└── FAQ_AND_BEST_PRACTICES.md        # Tips & troubleshooting
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Get Device ID
```bash
# List available iOS devices
xcrun simctl list devices | grep iPhone
```

### Step 2: Note Your UDID
Example: `00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE`

### Step 3: Build & Install App
```bash
cd /Users/jitendra/Documents/Demo_project/Bagisto_flutter

# Build app
flutter build ios --simulator

# Install/Run
flutter run
```

### Step 4: Run First Test
```bash
cd .maestro

# Make script executable (first time only)
chmod +x run_tests.sh

# Run smoke test
./run_tests.sh smoke 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
```

---

## 📋 Running Different Tests

### Using the Script (Easiest)
```bash
cd /Users/jitendra/Documents/Demo_project/Bagisto_flutter/.maestro

# List available devices
./run_tests.sh list

# Run specific tests
./run_tests.sh smoke <DEVICE_ID>      # 5 min
./run_tests.sh auth <DEVICE_ID>       # 5 min
./run_tests.sh home <DEVICE_ID>       # 5 min
./run_tests.sh product <DEVICE_ID>    # 8 min
./run_tests.sh cart <DEVICE_ID>       # 10 min
./run_tests.sh orders <DEVICE_ID>     # 8 min
./run_tests.sh account <DEVICE_ID>    # 10 min
./run_tests.sh all <DEVICE_ID>        # 50 min - All tests
```

### Using Maestro Directly
```bash
# Smoke test
maestro test flows/smoke_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE

# Complete suite
maestro test flows/master_flow.yaml --udid 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
```

---

## 📊 Test Coverage

| Feature | Status | Time | Tests |
|---------|--------|------|-------|
| App Launch | ✓ | 2 min | 5 |
| Authentication | ✓ | 5 min | 7 |
| Home Screen | ✓ | 5 min | 8 |
| Product Browsing | ✓ | 8 min | 12 |
| Cart Management | ✓ | 5 min | 9 |
| Checkout | ✓ | 5 min | 8 |
| Order History | ✓ | 8 min | 17 |
| Profile & Account | ✓ | 10 min | 23 |
| **Total** | **✓** | **50 min** | **100+ scenarios** |

---

## 🔧 Configuration

### Update Test Credentials
Edit `.maestro/flows/auth_flow.yaml` (around line 62):
```yaml
# Change these to your test account
- inputText: "test@example.com"
- inputText: "password123"
```

### Adjust Timeouts (if tests timeout)
Edit any flow file and increase `sleep` values:
```yaml
- sleep:
    ms: 5000  # Increase from 2000 to 5000
```

---

## 📖 Documentation Structure

1. **README.md** (Start here)
   - Complete overview
   - How to run tests
   - Detailed test descriptions
   - CI/CD integration examples

2. **CONFIGURATION.md** (For setup)
   - Device setup
   - Advanced selectors
   - Common patterns
   - CI/CD examples

3. **FAQ_AND_BEST_PRACTICES.md** (For tips)
   - Common questions
   - Best practices
   - Advanced techniques
   - Troubleshooting

---

## ✅ Test Scenarios Covered

### Authentication (7 tests)
- ✓ Valid login
- ✓ Invalid login error handling
- ✓ Sign up navigation
- ✓ Logout functionality
- ✓ Login state in Account tab
- ✓ Forgot password navigation
- ✓ Session persistence

### Home Screen (8 tests)
- ✓ App launch
- ✓ Banner carousel
- ✓ Category carousel
- ✓ Featured products
- ✓ Hot deals section
- ✓ Search functionality
- ✓ Back to top
- ✓ Tab navigation

### Products (12 tests)
- ✓ Browse categories
- ✓ Select category
- ✓ Product grid display
- ✓ Open product detail
- ✓ View product images
- ✓ Display pricing
- ✓ Add to cart
- ✓ Product reviews
- ✓ Back navigation
- ✓ Search products
- ✓ Product filtering
- ✓ Product sorting

### Cart & Checkout (17 tests)
- ✓ View cart items
- ✓ Quantity increase
- ✓ Quantity decrease
- ✓ Remove items
- ✓ Cart subtotal
- ✓ Proceed to checkout
- ✓ Enter shipping address
- ✓ Select shipping method
- ✓ Choose payment method
- ✓ Place order
- ✓ Order confirmation
- ✓ Empty cart handling
- ✓ Cart total calculation
- ✓ Item pricing
- ✓ Discount application
- ✓ Tax calculation
- ✓ Final total display

### Orders (17 tests)
- ✓ Navigate to Orders
- ✓ View order list
- ✓ Display order status
- ✓ Open order details
- ✓ View order ID
- ✓ See order items
- ✓ Display item prices
- ✓ Show item quantities
- ✓ Display order total
- ✓ Show order date
- ✓ Display shipping address
- ✓ Show tracking info
- ✓ Multiple orders handling
- ✓ Pagination
- ✓ Empty orders
- ✓ Order status badges
- ✓ Order actions

### Account & Profile (23 tests)
- ✓ Account dashboard
- ✓ View profile
- ✓ Edit profile form
- ✓ Update first name
- ✓ Update last name
- ✓ Change email
- ✓ Save profile
- ✓ Address book view
- ✓ Add new address
- ✓ Fill address form
- ✓ Save address
- ✓ Edit address
- ✓ Delete address
- ✓ Set default address
- ✓ Multiple addresses
- ✓ Orders section
- ✓ Wishlist access
- ✓ Saved items
- ✓ Compare products
- ✓ Reviews section
- ✓ Settings/preferences
- ✓ Logout functionality
- ✓ Session verification

---

## 🐛 Troubleshooting Quick Tips

| Issue | Solution |
|-------|----------|
| Tests timeout | Increase `sleep` values to 5000ms |
| Element not found | Check exact text match or use regex |
| Device not found | Verify UDID with `xcrun simctl list devices` |
| App not installed | Run `flutter run` first |
| Login fails | Update credentials in auth_flow.yaml |
| Navigation fails | Wait longer between actions (`sleep: {ms: 2000}`) |

---

## 📱 Device Info

### Get UDID
```bash
# List all simulators
xcrun simctl list devices

# Get specific device UDID
xcrun simctl list devices | grep "iPhone 15" | tail -1
```

### Boot Simulator
```bash
# Open simulator
open -a Simulator

# Boot specific simulator
xcrun simctl boot <udid>
```

---

## 🎯 Next Steps

1. **First Run**
   ```bash
   ./run_tests.sh smoke <YOUR_DEVICE_ID>
   ```

2. **Review Results**
   - Check `.maestro_artifacts/` for screenshots
   - Verify all assertions passed

3. **Run Full Suite**
   ```bash
   ./run_tests.sh all <YOUR_DEVICE_ID>
   ```

4. **Read Documentation**
   - Open [README.md](README.md) for complete guide
   - Check [FAQ_AND_BEST_PRACTICES.md](FAQ_AND_BEST_PRACTICES.md) for tips

5. **Integrate with CI/CD**
   - See [CONFIGURATION.md](CONFIGURATION.md) for GitHub Actions, GitLab CI, Jenkins examples
   - Get tests running in your pipeline

---

## 📝 Additional Commands

### View Test Results
```bash
# List all test artifacts
ls -la .maestro_artifacts/

# View latest screenshot
open .maestro_artifacts/*.png

# View test log
cat .maestro_artifacts/log.txt
```

### Run with Custom Options
```bash
# Run specific device
maestro test flows/smoke_flow.yaml --udid YOUR_DEVICE_ID

# Show verbose output
maestro test flows/smoke_flow.yaml --udid YOUR_DEVICE_ID -v

# Set timeout
maestro test flows/smoke_flow.yaml --udid YOUR_DEVICE_ID --timeout 300

# Continue on failure
maestro test flows/smoke_flow.yaml --udid YOUR_DEVICE_ID --continue-on-failure
```

---

## 🚦 Success Indicators

✅ Test suite is working if you see:
- Tests start and execute commands
- Screenshots appear in `.maestro_artifacts/`
- Console shows "...PASSED" at end of each test
- No error messages about missing elements

---

## 📞 Support Resources

- **Maestro Official**: https://maestro.mobile/
- **Flutter Docs**: https://flutter.dev/
- **Bagisto Flutter**: https://bagisto.com/flutter/

---

## 🎓 Learning Path

1. **Beginner**: Run smoke_flow.yaml
2. **Intermediate**: Run individual flows (auth, home, product)
3. **Advanced**: Run master_flow.yaml and customize tests
4. **Expert**: Extend test suite with new features

---

**Version**: 1.0  
**Created**: February 2026  
**Test Framework**: Maestro 1.35.0+  
**App Framework**: Flutter 3.0+  
**Platform**: iOS 12.0+

---

**Happy Testing! 🎉**

For issues or questions, refer to:
- FAQ_AND_BEST_PRACTICES.md
- CONFIGURATION.md
- README.md

