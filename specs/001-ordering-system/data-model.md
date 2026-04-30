# Data Model: Minoo Delivery Ordering System

**Feature**: 001-ordering-system
**Date**: 2026-04-30
**Source**: spec.md entities + research.md API analysis + existing codebase

---

## Existing Models (No Changes Required)

### `MenuItem` — `lib/utils/menu_item.dart`

| Field | Type | Notes |
|---|---|---|
| `id` | `int` | Primary key |
| `vendorId` | `String` | Links item to vendor |
| `publicId` | `String` | External public reference |
| `menuName` | `String` | Display name |
| `menuDescription` | `String` | Description text |
| `menuPrice` | `double` | Unit price in Birr |
| `menuImg` | `String` | Relative path; `imageUrl` getter builds full URL |
| `menuCategory` | `String?` | Optional category tag |
| `createdAt` | `DateTime` | ISO timestamp |
| `updatedAt` | `DateTime` | ISO timestamp |

**Computed**: `imageUrl` → `https://minoodelivery.com/public/{menuImg}`

---

### `DeliveryCenter` — `lib/models/delivery_center_model.dart`

| Field | Type | Notes |
|---|---|---|
| `id` | `int` | Primary key |
| `name` | `String` | Display name |
| `slug` | `String` | URL slug |

---

### `Destination` — `lib/models/destination_address.dart`

| Field | Type | Notes |
|---|---|---|
| `id` | `int` | Primary key |
| `deliveryCenterId` | `int` | Parent center |
| `name` | `String` | Display name (e.g., "Home", "Office") |
| `slug` | `String` | URL slug |
| `distance` | `String` | Distance from center (parsed to double for calculation) |

---

### `CartItem` — `lib/providers/menu/cart_provider.dart`

| Field | Type | Notes |
|---|---|---|
| `food` | `MenuItem` | The item |
| `quantity` | `int` | Mutable, 1–10 |

---

## New Models (To Be Created)

### `Order` — `lib/models/order_model.dart`

Represents a completed or in-progress transaction.

| Field | Type | Notes |
|---|---|---|
| `id` | `int` | Server-assigned primary key |
| `orderType` | `OrderType` | Enum: `single` / `cart` |
| `status` | `OrderStatus` | Enum: see status model below |
| `deliveryCenterId` | `int` | FK → DeliveryCenter |
| `deliveryCenterName` | `String` | Denormalized for display |
| `destinationId` | `int` | FK → Destination |
| `destinationName` | `String` | Denormalized for display |
| `itemsSubtotal` | `double` | Sum of item prices × quantities |
| `deliveryPrice` | `double` | `distance × 50` |
| `totalPrice` | `double` | `itemsSubtotal + deliveryPrice` |
| `paymentScreenshotUrl` | `String?` | URL returned by server after upload |
| `items` | `List<OrderItem>` | Empty for single orders; list for cart orders |
| `singleItem` | `OrderItem?` | Populated for single orders; null for cart |
| `createdAt` | `DateTime` | Server timestamp |

**Enums**:
```dart
enum OrderType { single, cart }

enum OrderStatus { pending, processing, outForDelivery, completed }
```

**`fromJson` mapping**:
```
id                    ← json['id']
order_type            ← json['order_type'] → OrderType
status                ← json['status'] → OrderStatus
delivery_center_id    ← json['delivery_center_id']
delivery_center_name  ← json['delivery_center_name']
destination_id        ← json['destination_id']
destination_name      ← json['destination_name']
items_subtotal        ← double.parse(json['items_subtotal'])
delivery_price        ← double.parse(json['delivery_price'])
total_price           ← double.parse(json['total_price'])
payment_screenshot_url← json['payment_screenshot_url']
items                 ← List<OrderItem>.fromJson(json['items'] ?? [])
created_at            ← DateTime.parse(json['created_at'])
```

---

### `OrderItem` — `lib/models/order_item_model.dart`

Represents a single line item within any order.

| Field | Type | Notes |
|---|---|---|
| `id` | `int` | Server-assigned |
| `orderId` | `int` | Parent order FK |
| `menuId` | `int` | FK → MenuItem |
| `menuName` | `String` | Denormalized for display |
| `menuImageUrl` | `String` | Full URL for display |
| `vendorId` | `String` | FK → Vendor (for zone deduplication server-side) |
| `unitPrice` | `double` | Price at time of order |
| `quantity` | `int` | Ordered quantity |
| `lineTotal` | `double` | `unitPrice × quantity` (computed or server-provided) |

**`fromJson` mapping**:
```
id            ← json['id']
order_id      ← json['order_id']
menu_id       ← json['menu_id']
menu_name     ← json['menu_name']
menu_image_url← json['menu_image_url']
vendor_id     ← json['vendor_id']
unit_price    ← double.parse(json['unit_price'])
quantity      ← json['quantity']
line_total    ← double.parse(json['line_total'])
```

---

## State Transitions

```
Order Status FSM:
                    Admin action          Admin action        Admin action
  [pending] ──────────────────► [processing] ──────────────► [out_for_delivery] ──────► [completed]
      ▲
  Created on
  order submit
```

- `pending`: Payment screenshot uploaded; awaiting admin verification.
- `processing`: Admin confirmed payment; vendor is preparing.
- `out_for_delivery`: Driver collected from Delivery Center.
- `completed`: User received items.

User can only **read** status. Only admin transitions status.

---

## Pricing Formulas

### Express Order
```
shippingFee = distanceCenterToDestination × 50
total = itemPrice × quantity + shippingFee
```

### Cart Order
```
itemsSubtotal = Σ (unitPrice × quantity) for all cart items
shippingFee   = (Σ unique vendor zone distances to center + distanceCenterToDestination) × 50
total         = itemsSubtotal + shippingFee
```

**Note**: In v1, `shippingFee` for cart orders is computed server-side on `POST /orders`
because vendor zone distance data is not yet exposed client-side.
The app sends item list; server responds with confirmed `delivery_price`.

---

## Provider / Repository Mapping

| Layer | File | Responsibility |
|---|---|---|
| Model | `lib/models/order_model.dart` | Deserialization, enums |
| Model | `lib/models/order_item_model.dart` | Line-item deserialization |
| Service | `lib/services/order/order_api_service.dart` | HTTP multipart POST, GET |
| Repository | `lib/repositories/order/order_repository.dart` | Calls service, returns typed models |
| Provider | `lib/providers/order/order_provider.dart` | Express + cart order submission state |
| Provider | `lib/providers/order/order_history_provider.dart` | User order history async state |
