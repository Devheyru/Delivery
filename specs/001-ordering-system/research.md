# Research: Minoo Delivery Ordering System

**Feature**: 001-ordering-system
**Date**: 2026-04-30
**Status**: Complete — all unknowns resolved

---

## 1. Backend API Surface (Existing)

**Decision**: The project already consumes a REST API hosted at `https://minoodelivery.com`.

Confirmed live endpoints from code inspection:

| Endpoint | Method | Purpose |
|---|---|---|
| `GET /menus` | GET | Fetch all menu listings (returns array or `{data:[]}`) |
| `GET /delivery-zones` | GET | Fetch all delivery centers |
| `GET /delivery-zones/destinations/{centerId}` | GET | Fetch destinations for a center |
| `GET /delivery-zones/distance/{centerId}/{destinationId}` | GET | Fetch distance (double, km) |

**Missing endpoints** (must be designed):

| Endpoint | Method | Purpose |
|---|---|---|
| `POST /orders` | POST | Submit a new order (express or cart) |
| `GET /orders?user_id={id}` | GET | Fetch user's order history |
| `GET /orders/{orderId}` | GET | Fetch single order detail |

**Rationale**: The backend already handles logistics data. Order submission and
retrieval endpoints follow the same REST pattern already established.

---

## 2. Order Submission Payload (Express vs Cart)

**Decision**: Single unified `POST /orders` endpoint that discriminates on `order_type`.

**Express Order payload**:
```json
{
  "order_type": "single",
  "menu_id": 42,
  "vendor_id": "v_001",
  "quantity": 1,
  "delivery_center_id": 3,
  "destination_id": 7,
  "item_price": 120.0,
  "delivery_price": 250.0,
  "total_price": 370.0,
  "payment_screenshot": "<multipart file>"
}
```

**Cart Order payload**:
```json
{
  "order_type": "cart",
  "delivery_center_id": 3,
  "destination_id": 7,
  "items": [
    { "menu_id": 42, "vendor_id": "v_001", "quantity": 2, "unit_price": 120.0 },
    { "menu_id": 19, "vendor_id": "v_002", "quantity": 1, "unit_price": 85.0 }
  ],
  "items_subtotal": 325.0,
  "delivery_price": 350.0,
  "total_price": 675.0,
  "payment_screenshot": "<multipart file>"
}
```

**Rationale**: Mirrors the SRS data model (`cart_items[]`, `cart_delivery_price`,
`cart_tpss`, `destination_id`). The `multipart/form-data` encoding is required for
the screenshot upload.

---

## 3. Distance Calculation — Multi-Vendor Deduplication

**Decision**: Zone-to-center distances are summed per **unique vendor zone**.
The `MenuItem.vendorId` field maps to a vendor; zones are fetched server-side.

**Current gap**: `MenuItem` has a `vendorId` (String) but the API currently has
no `GET /vendors/{vendorId}/zone` endpoint to resolve zone → center distance.

**Resolution**: The existing `GET /delivery-zones/distance/{centerId}/{destinationId}`
endpoint handles center→destination. For cart orders with multiple vendors,
the app needs a new endpoint or the cart total must be computed server-side.

**Chosen approach**: For v1, delegate total delivery price computation to the
server on `POST /orders` using the submitted item list. The client shows
individual item prices; the server returns the confirmed `delivery_price`
in the order response.

**Alternative considered**: Client-side computation per vendor zone. Rejected
because vendor zone distance data is not yet exposed via API.

---

## 4. Payment Screenshot Upload

**Decision**: Use `multipart/form-data` with `image_picker` (already in pubspec).
The `XFile` from gallery → upload as `cart_tpss` field matching the SRS field name.

**Current state**: `payment_Proof.dart` picks the image but has `TODO: Upload file
to server`. This is the primary gap to implement.

**Rationale**: `image_picker` + `http` package (already present) is sufficient.
No cloud storage SDK needed — backend stores the file.

---

## 5. Order History & Status

**Decision**: A new `OrderHistoryPage` fetches `GET /orders?user_id={id}`.
User identity is available via the existing auth/session (login page already exists).

**Status transitions** (admin-controlled, read-only for user):
`pending` → `processing` → `out_for_delivery` → `completed`

**Implementation**: `FutureProvider` polling or manual refresh (pull-to-refresh).
Real-time via WebSocket is out of scope for v1.

---

## 6. Express "Order Now" Flow (New Screen Required)

**Decision**: A new `ExpressCheckoutPage` is needed. Currently `DetailsPage` only
supports "Add to Cart". A separate "Order Now" button routes to
`ExpressCheckoutPage` which reuses:
- `deliveryCentersProvider` (already exists)
- `destinationsProvider` (already exists)
- `distanceProvider` (already exists)
- `showPaymentDialog()` (already exists)

**New provider needed**: `expressOrderProvider` (StateNotifier) that holds the
selected center, destination, and calculated total for a single item.

---

## 7. State Management Pattern Decisions

**Decision**: Follow the existing Riverpod pattern throughout:
- `FutureProvider` for all async reads (API calls)
- `StateNotifierProvider` for mutable state (cart, express order)
- `StateProvider` for simple selected-value state (selected center, destination)

No `ChangeNotifier` or `setState`-heavy patterns — constitution principle III.

---

## 8. File Structure Gaps to Fill

New files required (not yet present):

```
lib/
  models/
    order_model.dart           ← NEW
    order_item_model.dart      ← NEW
  repositories/
    order/
      order_repository.dart    ← NEW
  services/
    order/
      order_api_service.dart   ← NEW
  providers/
    order/
      order_provider.dart      ← NEW
      order_history_provider.dart ← NEW
  pages/
    express_checkout.dart      ← NEW
    order_history.dart         ← NEW
    order_detail.dart          ← NEW
```

All existing files remain unchanged; this feature only **adds** new files.
