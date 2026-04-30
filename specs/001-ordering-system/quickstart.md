# Quickstart: Minoo Delivery Ordering System

**Feature**: 001-ordering-system
**Date**: 2026-04-30
**Purpose**: Developer guide to run, test, and validate the ordering feature end-to-end

---

## Prerequisites

- Flutter SDK ^3.7.2 (stable channel)
- Android Studio or VS Code with Flutter extension
- Android emulator or physical device (Android 8+)
- Active internet connection (app connects to `https://minoodelivery.com`)
- `flutter pub get` run inside `minoo_deleivery/`

```powershell
cd minoo_deleivery
flutter pub get
```

---

## Run the App

```powershell
# Development (with DevicePreview overlay)
flutter run

# Specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

The app launches on `Onboarding` → `Login` → `Home`. DevicePreview is enabled in
debug mode for multi-device testing.

---

## Validate User Story 1 — Express Single-Item Order

1. Log in with a valid account
2. On the Home screen, tap any menu item card
3. On `DetailsPage`, verify "Order Now" button is visible *(to be implemented)*
4. Tap "Order Now" → `ExpressCheckoutPage` opens *(to be implemented)*
5. Select a **Delivery Center** from the dropdown
6. Select a **Destination** from the second dropdown (filtered by center)
7. Verify the total price display: `Item Price + (distance × 50)`
8. Tap "Check Out" → payment dialog opens
9. Tap "Choose File" → select a screenshot from gallery
10. Tap "Submit"
11. Verify success snackbar + navigation to order history

**Expected result**: New order appears in Order History with status **Pending**
and type badge **Single Item**.

---

## Validate User Story 2 — Cart Multi-Vendor Order

1. Log in and browse listings
2. Open an item → tap "Add to Cart" (quantity ≥ 1)
3. Repeat with a second item from a **different vendor** (different `vendorId`)
4. Tap the cart icon → `CartPage` opens
5. Verify both items are listed with correct quantities
6. Tap "Edit" next to Delivery Address → `AddressPage` → select center + destination
7. Verify the **Total** price shown at the bottom of CartPage
8. Tap "Place Order" → `CheckoutSummaryPage` opens
9. Verify order summary card shows correct subtotal, shipping, and total
10. Tap "Check Out" → payment dialog → upload screenshot → Submit
11. Verify success + cart cleared

**Expected result**: New order appears in Order History with status **Pending**
and type badge **Cart Order** with expandable item list.

---

## Validate User Story 3 — Order Status Tracking

1. Complete any order (US1 or US2)
2. Navigate to **Order History** (dashboard icon) *(to be implemented)*
3. Verify order appears with correct:
   - Type badge (Single Item / Cart Order)
   - Delivery Center and Destination names
   - Status label: **Pending**
4. Have admin advance status in backend
5. Pull-to-refresh on Order History
6. Verify status label updates: **Processing** → **Out for Delivery** → **Completed**

---

## Key API Endpoints (for manual testing with curl)

```bash
# Fetch menus
curl https://minoodelivery.com/menus

# Fetch delivery centers
curl https://minoodelivery.com/delivery-zones

# Fetch destinations for center ID 3
curl https://minoodelivery.com/delivery-zones/destinations/3

# Fetch distance (center 3 → destination 7)
curl https://minoodelivery.com/delivery-zones/distance/3/7

# Submit order (replace fields as needed)
curl -X POST https://minoodelivery.com/orders \
  -F "order_type=single" \
  -F "menu_id=42" \
  -F "vendor_id=v_001" \
  -F "quantity=1" \
  -F "delivery_center_id=3" \
  -F "destination_id=7" \
  -F "item_price=120" \
  -F "delivery_price=250" \
  -F "total_price=370" \
  -F "cart_tpss=@/path/to/screenshot.jpg"

# Fetch order history
curl "https://minoodelivery.com/orders?user_id=123"
```

---

## Run Static Analysis

```powershell
cd minoo_deleivery
flutter analyze
```

**Expected**: Zero errors, zero warnings (constitution requirement).

---

## Common Issues

| Issue | Cause | Fix |
|---|---|---|
| Distance shows "Error calculating distance" | API unreachable or invalid center/destination combo | Check network; verify IDs exist in backend |
| Cart total shows 0 | `menuPrice` is 0.0 (parsing failed) | Check `menu_price` field in API response |
| Payment dialog submits but no order created | `TODO` in `payment_Proof.dart` not yet implemented | Implement `OrderApiService.submitOrder()` |
| Image not loading in cart | `imageUrl` getter mismatch | Verify `menuImg` path format from API |
