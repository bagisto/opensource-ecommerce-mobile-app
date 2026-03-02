#!/bin/bash

###############################################################################
# Bagisto Flutter - Maestro Test Runner Script
# 
# This script provides convenient commands to run Maestro tests
# 
# Usage:
#   ./run_tests.sh smoke          - Run smoke tests
#   ./run_tests.sh auth           - Run authentication tests
#   ./run_tests.sh home           - Run home screen tests
#   ./run_tests.sh product        - Run product tests
#   ./run_tests.sh cart           - Run cart & checkout tests
#   ./run_tests.sh orders         - Run orders tests
#   ./run_tests.sh account        - Run account tests
#   ./run_tests.sh all            - Run all tests (master flow)
#   ./run_tests.sh list           - List available devices
#   ./run_tests.sh <flow> <udid>  - Run specific flow with device ID
#
###############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FLOWS_DIR="$SCRIPT_DIR/flows"

# Default device (you can override with second argument)
DEVICE_ID="${2:-}"

# Functions
print_banner() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

list_devices() {
    print_banner "Available iOS Devices"
    xcrun simctl list devices available | grep -E "iPhone|iPad" || echo "No devices found"
}

get_default_device() {
    # Try to find first available simulator
    local devices=$(xcrun simctl list devices available | grep -E '^\s+[A-F0-9]{8}-[A-F0-9]{4}' | head -1)
    if [ -n "$devices" ]; then
        echo "$devices" | awk '{print $(NF-1)}' | tr -d '()'
    fi
}

run_test() {
    local flow_name=$1
    local device_id=$2
    
    if [ -z "$device_id" ]; then
        print_error "Device ID not specified. Run './run_tests.sh list' to see available devices."
        exit 1
    fi
    
    local flow_file="$FLOWS_DIR/${flow_name}_flow.yaml"
    
    if [ ! -f "$flow_file" ]; then
        print_error "Flow file not found: $flow_file"
        exit 1
    fi
    
    print_banner "Running: ${flow_name} Flow"
    print_info "Device: $device_id"
    print_info "Flow: $flow_file"
    
    if maestro test "$flow_file" --udid "$device_id"; then
        print_success "${flow_name} flow completed successfully"
        return 0
    else
        print_error "${flow_name} flow failed"
        return 1
    fi
}

run_all_tests() {
    local device_id=$1
    
    if [ -z "$device_id" ]; then
        print_error "Device ID not specified. Run './run_tests.sh list' to see available devices."
        exit 1
    fi
    
    print_banner "Running: Complete E2E Test Suite"
    print_info "Device: $device_id"
    
    maestro test "$FLOWS_DIR/master_flow.yaml" --udid "$device_id"
}

show_help() {
    cat << EOF
${BLUE}Bagisto Flutter - Maestro Test Runner${NC}

${GREEN}Usage:${NC}
  ./run_tests.sh [command] [device_id]

${GREEN}Commands:${NC}
  smoke              Run smoke tests (quick health check)
  auth               Run authentication tests
  home               Run home screen tests
  product            Run product browsing tests
  cart               Run cart & checkout tests
  orders             Run order management tests
  account            Run account & profile tests
  all                Run all tests (complete E2E suite)
  list               List available iOS devices
  help               Show this help message

${GREEN}Examples:${NC}
  ./run_tests.sh list
  ./run_tests.sh smoke 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE
  ./run_tests.sh all 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE

${GREEN}Device ID Format:${NC}
  Use full UDID from: ./run_tests.sh list
  Example: 00F3D8B0-F068-4BE9-A08A-5CB11F6E79BE

${GREEN}Notes:${NC}
  - If device ID is omitted, it will attempt to use the first available device
  - Ensure the app is installed on the target device before running tests
  - Check .maestro_artifacts/ for test results and screenshots
  - Update test credentials in flows/auth_flow.yaml before running

${BLUE}For more information, see:${NC}
  - README.md - Complete test documentation
  - CONFIGURATION.md - Setup and configuration guide

EOF
}

# Main script logic
case "${1:-help}" in
    smoke)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "smoke" "$DEVICE_ID"
        ;;
    auth)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "auth" "$DEVICE_ID"
        ;;
    home)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "home" "$DEVICE_ID"
        ;;
    product)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "product" "$DEVICE_ID"
        ;;
    cart)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "cart_checkout" "$DEVICE_ID"
        ;;
    orders)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "orders" "$DEVICE_ID"
        ;;
    account)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_test "account" "$DEVICE_ID"
        ;;
    all)
        DEVICE_ID="${DEVICE_ID:-$(get_default_device)}"
        run_all_tests "$DEVICE_ID"
        ;;
    list)
        list_devices
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        # Allow custom flow names
        if [ -f "$FLOWS_DIR/${1}_flow.yaml" ]; then
            run_test "$1" "$DEVICE_ID"
        else
            print_error "Unknown command: $1"
            show_help
            exit 1
        fi
        ;;
esac

