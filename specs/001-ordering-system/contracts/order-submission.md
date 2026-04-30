# API Contract: Order Submission

**Endpoint**: `POST https://minoodelivery.com/orders`
**Content-Type**: `multipart/form-data`
**Auth**: Session cookie / Bearer token (user must be authenticated)

---

## Express Order (single item)

### Request Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `order_type` | `string` | ✅ | Must be `"single"` |
| `menu_id` | `integer` | ✅ | ID of the ordered menu item |
| `vendor_id` | `string` | ✅ | Vendor who owns the item |
| `quantity` | `integer` | ✅ | 1–10 |
| `delivery_center_id` | `integer` | ✅ | Selected delivery center |
| `destination_id` | `integer` | ✅ | Selected drop-off destination |
| `item_price` | `decimal` | ✅ | Unit price × quantity (Birr) |
| `delivery_price` | `decimal` | ✅ | `distance × 50` (Birr) |
| `total_price` | `decimal` | ✅ | `item_price + delivery_price` |
| `cart_tpss` | `file` | ✅ | Payment screenshot (JPEG/PNG, max 5MB) |

### Example Request (multipart)
```
POST /orders
Content-Type: multipart/form-data; boundary=----Boundary

------Boundary
Content-Disposition: form-data; name="order_type"
single
------Boundary
Content-Disposition: form-data; name="menu_id"
42
------Boundary
Content-Disposition: form-data; name="vendor_id"
v_001
------Boundary
Content-Disposition: form-data; name="quantity"
1
------Boundary
Content-Disposition: form-data; name="delivery_center_id"
3
------Boundary
Content-Disposition: form-data; name="destination_id"
7
------Boundary
Content-Disposition: form-data; name="item_price"
120.00
------Boundary
Content-Disposition: form-data; name="delivery_price"
250.00
------Boundary
Content-Disposition: form-data; name="total_price"
370.00
------Boundary
Content-Disposition: form-data; name="cart_tpss"; filename="screenshot.jpg"
Content-Type: image/jpeg
<binary data>
------Boundary--
```

---

## Cart Order (multi-vendor)

### Request Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `order_type` | `string` | ✅ | Must be `"cart"` |
| `delivery_center_id` | `integer` | ✅ | Selected delivery center |
| `destination_id` | `integer` | ✅ | Selected drop-off destination |
| `items` | `string` (JSON) | ✅ | JSON array of cart items (see below) |
| `items_subtotal` | `decimal` | ✅ | Sum of all line totals (Birr) |
| `delivery_price` | `decimal` | ✅ | Server-confirmed shipping fee (Birr) |
| `total_price` | `decimal` | ✅ | `items_subtotal + delivery_price` |
| `cart_tpss` | `file` | ✅ | Single payment screenshot (JPEG/PNG, max 5MB) |

### `items` JSON Array Schema
```json
[
  {
    "menu_id": 42,
    "vendor_id": "v_001",
    "menu_name": "Tibs",
    "quantity": 2,
    "unit_price": 120.00,
    "line_total": 240.00
  },
  {
    "menu_id": 19,
    "vendor_id": "v_002",
    "menu_name": "Fruit Basket",
    "quantity": 1,
    "unit_price": 85.00,
    "line_total": 85.00
  }
]
```

---

## Success Response — Both Order Types

**Status**: `201 Created`

```json
{
  "id": 1051,
  "order_type": "cart",
  "status": "pending",
  "delivery_center_id": 3,
  "delivery_center_name": "Bole Hub",
  "destination_id": 7,
  "destination_name": "Sarbet Office",
  "items_subtotal": 325.00,
  "delivery_price": 350.00,
  "total_price": 675.00,
  "payment_screenshot_url": "https://minoodelivery.com/public/payments/1051.jpg",
  "items": [
    {
      "id": 2001,
      "order_id": 1051,
      "menu_id": 42,
      "menu_name": "Tibs",
      "menu_image_url": "https://minoodelivery.com/public/menus/tibs.jpg",
      "vendor_id": "v_001",
      "unit_price": 120.00,
      "quantity": 2,
      "line_total": 240.00
    }
  ],
  "created_at": "2026-04-30T12:00:00Z"
}
```

---

## Error Responses

| Status | Code | Meaning |
|---|---|---|
| `400` | `MISSING_FIELD` | Required field absent |
| `400` | `INVALID_FILE` | Screenshot not a valid image or exceeds 5MB |
| `401` | `UNAUTHENTICATED` | User not logged in |
| `422` | `INVALID_TOTAL` | `total_price` does not match server calculation |
| `500` | `SERVER_ERROR` | Unexpected server failure |

```json
{
  "error": "MISSING_FIELD",
  "message": "cart_tpss is required"
}
```
