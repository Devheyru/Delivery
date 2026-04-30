# API Contract: Order History & Detail

**Base URL**: `https://minoodelivery.com`
**Auth**: Session cookie / Bearer token

---

## GET /orders — Fetch User Order History

### Request

| Parameter | Type | Location | Required | Description |
|---|---|---|---|---|
| `user_id` | `integer` | Query | ✅ | Authenticated user's ID |
| `page` | `integer` | Query | ❌ | Page number (default: 1) |
| `per_page` | `integer` | Query | ❌ | Results per page (default: 20) |

```
GET /orders?user_id=123&page=1&per_page=20
```

### Success Response — `200 OK`

```json
{
  "data": [
    {
      "id": 1051,
      "order_type": "cart",
      "status": "processing",
      "delivery_center_name": "Bole Hub",
      "destination_name": "Sarbet Office",
      "items_subtotal": 325.00,
      "delivery_price": 350.00,
      "total_price": 675.00,
      "payment_screenshot_url": "https://minoodelivery.com/public/payments/1051.jpg",
      "items": [
        {
          "id": 2001,
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
    },
    {
      "id": 1042,
      "order_type": "single",
      "status": "completed",
      "delivery_center_name": "Megenagna Hub",
      "destination_name": "Home",
      "items_subtotal": 120.00,
      "delivery_price": 100.00,
      "total_price": 220.00,
      "payment_screenshot_url": "https://minoodelivery.com/public/payments/1042.jpg",
      "items": [
        {
          "id": 1980,
          "menu_id": 15,
          "menu_name": "Shiro",
          "menu_image_url": "https://minoodelivery.com/public/menus/shiro.jpg",
          "vendor_id": "v_003",
          "unit_price": 120.00,
          "quantity": 1,
          "line_total": 120.00
        }
      ],
      "created_at": "2026-04-28T09:30:00Z"
    }
  ],
  "total": 8,
  "page": 1,
  "per_page": 20
}
```

---

## GET /orders/{orderId} — Fetch Single Order Detail

```
GET /orders/1051
```

### Success Response — `200 OK`

Same shape as a single object from the list above, with full `items` array.

---

## Status Values

| API Value | Display Label | UI Color |
|---|---|---|
| `pending` | Pending | Amber/Orange |
| `processing` | Processing | Blue |
| `out_for_delivery` | Out for Delivery | Purple |
| `completed` | Completed | Green |

---

## Error Responses

| Status | Code | Meaning |
|---|---|---|
| `401` | `UNAUTHENTICATED` | User not logged in |
| `403` | `FORBIDDEN` | Order does not belong to user |
| `404` | `NOT_FOUND` | Order ID not found |
