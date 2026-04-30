# Feature Specification: Minoo Delivery Ordering System

**Feature Branch**: `001-ordering-system`
**Created**: 2026-04-30
**Status**: Draft
**Input**: Derived from SRS (srs.html), project constitution, codebase analysis, and README

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Express Single-Item Order (Priority: P1)

A registered user browses a listing (menu dish, hotel/restaurant item, or fruit item),
taps "Order Now" on a single item, selects a Delivery Center, selects their final
destination (Home or Office), reviews the auto-calculated total price, uploads a
payment screenshot, and submits the order.

**Why this priority**: This is the simplest and most common ordering flow. It delivers
immediate value to customers who want a single item fast, and forms the foundation
for all other order-related features.

**Independent Test**: Can be fully tested by placing a single-item order end-to-end
(browse → "Order Now" → select center & destination → view price → upload screenshot
→ confirm) and verifying the order appears in the user's dashboard with status
"Pending".

**Acceptance Scenarios**:

1. **Given** a user is viewing a menu item listing, **When** they tap "Order Now",
   **Then** they are taken to the express checkout screen showing item details,
   a Delivery Center selector, a destination selector, and the calculated total price.

2. **Given** a user has selected a Delivery Center and a final destination,
   **When** the system calculates the price, **Then** the total equals
   `Item Price + ((distance from vendor zone to center + distance from center to destination) × 50 Br)`.

3. **Given** a user has reviewed the total, **When** they upload a payment screenshot
   and tap "Confirm Order", **Then** a new order record is created with status "Pending"
   and the user sees a success confirmation.

4. **Given** a user has placed an express order, **When** they open their dashboard,
   **Then** the order appears labelled as "Single Item" with the item name, image,
   vendor name, chosen Delivery Center, destination, and status "Pending".

---

### User Story 2 - Cart Multi-Vendor Order (Priority: P2)

A registered user adds items from one or more vendors (from different zones) to a
cart, reviews the aggregated cart with a consolidated delivery price, selects a
single Delivery Center and final destination, uploads one master payment screenshot,
and submits the full cart as a single transaction.

**Why this priority**: Enables bulk/grocery-style shopping across multiple vendors
in one transaction — the key differentiator for the platform's "Collector" workflow.

**Independent Test**: Can be fully tested by adding 2+ items from different vendor
zones to the cart, proceeding to checkout, verifying the price formula aggregates
unique vendor zone distances, uploading a screenshot, and confirming the order
appears as a "Cart Order" in the dashboard with an expandable item list.

**Acceptance Scenarios**:

1. **Given** a user is viewing any listing, **When** they tap "Add to Cart",
   **Then** the item is added to their cart with quantity defaulting to 1,
   and the cart icon shows the updated item count.

2. **Given** a user has items from multiple vendor zones in the cart,
   **When** they proceed to checkout and select a Delivery Center and destination,
   **Then** the total equals:
   `(Sum of all item prices × quantities) + ((Σ unique vendor zone distances to center + center to destination) × 50 Br)`.

3. **Given** a user has reviewed the consolidated total, **When** they upload one
   payment screenshot and tap "Confirm Order", **Then** all cart items are submitted
   as a single order record with status "Pending" and the cart is cleared.

4. **Given** a user has placed a cart order, **When** they open their dashboard,
   **Then** the order appears labelled "Cart Order" with an expandable list showing
   all items, the chosen Delivery Center, destination, and status "Pending".

---

### User Story 3 - Order Status Tracking (Priority: P3)

A registered user can view their full order history and track the real-time status
of each order through four stages: Pending → Processing → Out for Delivery → Completed.

**Why this priority**: Transparency on order status is essential for user trust and
reduces support requests. Builds on the order data created by US1 and US2.

**Independent Test**: Can be fully tested by placing any order (US1 or US2),
then verifying the dashboard shows the correct status label and that each status
change (simulated via admin) is reflected in the user's order history view.

**Acceptance Scenarios**:

1. **Given** a user has one or more orders, **When** they open the dashboard,
   **Then** each order shows its type badge (Single Item / Cart Order), the
   Delivery Center, destination, and current status label.

2. **Given** an admin confirms a payment, **When** the user views their dashboard,
   **Then** the order status updates from "Pending" to "Processing".

3. **Given** a driver collects the order from the Delivery Center, **When** the
   admin marks it dispatched, **Then** the order status updates to "Out for Delivery".

4. **Given** the user receives their items, **When** the admin marks it complete,
   **Then** the order status updates to "Completed".

---

### Edge Cases

- What happens when no Delivery Centers are configured for a vendor's zone?
  → The system MUST show a clear message: "No delivery centers available for this
  vendor's area" and prevent order submission.
- What happens if the user uploads a corrupted or unreadable payment screenshot?
  → The system MUST show a validation error and prompt the user to re-upload a
  valid image file.
- What happens when a cart contains two items from the same vendor zone?
  → The system MUST count that vendor zone only once in the distance aggregation
  (unique zone deduplication).
- What happens if a user tries to order an item from a vendor in a zone that has
  no distance data to any Delivery Center?
  → The system MUST block order placement and display an informative error.
- What happens when the user's cart is empty and they navigate to checkout?
  → The checkout screen MUST be inaccessible; the cart page shows an empty state
  with a prompt to browse listings.

---

## Requirements *(mandatory)*

### Functional Requirements

**Express Ordering (US1)**

- **FR-001**: The system MUST allow users to initiate an express order from any
  menu, hotel/restaurant, or fruit listing via a clearly labelled "Order Now" button.
- **FR-002**: The system MUST present a Delivery Center selector populated with
  all centers available for the vendor's zone.
- **FR-003**: The system MUST present a destination selector with the user's saved
  locations (Home, Office, or custom).
- **FR-004**: The system MUST calculate and display the total price as:
  `Item Price + (Segment 1 distance + Segment 2 distance) × 50 Br`,
  where Segment 1 = vendor zone → center, Segment 2 = center → destination.
- **FR-005**: The system MUST allow the user to upload exactly one payment screenshot
  per express order before submission.
- **FR-006**: The system MUST create an order record with type "Single Item" and
  status "Pending" upon successful submission.

**Cart Ordering (US2)**

- **FR-007**: The system MUST allow users to add items from any listing type
  (menu, hotel, fruit) to a persistent cart.
- **FR-008**: The system MUST allow users to adjust item quantities or remove
  items from the cart before checkout.
- **FR-009**: The system MUST aggregate cart pricing as:
  `(Σ item price × quantity) + (Σ unique vendor zone distances to center + center to destination) × 50 Br`.
- **FR-010**: The system MUST deduplicate vendor zones when calculating delivery
  costs (items from the same zone count as one distance segment).
- **FR-011**: The system MUST allow a single payment screenshot upload for the
  entire cart order.
- **FR-012**: The system MUST create an order record with type "Cart Order" and
  status "Pending" upon successful cart submission, and clear the cart afterwards.

**Order Status & Dashboard (US3)**

- **FR-013**: The system MUST display an order history list on the user dashboard
  showing all past and active orders.
- **FR-014**: Each order entry MUST display its type badge (Single Item / Cart Order),
  the Delivery Center used, the destination, the total paid, and the current status.
- **FR-015**: Single Item orders MUST show the item name, image, and vendor name
  directly on the order entry.
- **FR-016**: Cart Orders MUST show an expandable list of all items in the transaction.
- **FR-017**: The system MUST support four order statuses:
  Pending → Processing → Out for Delivery → Completed.
- **FR-018**: Status transitions MUST be admin-controlled; users can only read status,
  not modify it.

### Key Entities

- **Order**: Represents a completed transaction. Has type (Single Item / Cart Order),
  status, delivery center reference, destination reference, total price, payment
  screenshot reference, and timestamp.
- **OrderItem**: A line item within a Cart Order. Has a reference to the listing
  (menu_id or fruit_id), vendor_id, unit price, and quantity.
- **Listing**: A purchasable item (menu dish, hotel item, or fruit). Has name,
  image, price, and a vendor_id.
- **Vendor**: A restaurant, hotel, or fruit shop. Belongs to a Zone.
- **Zone**: A geographic area. Is the source point for Segment 1 distance calculation.
- **DeliveryCenter**: The hub facility. Has distances to each Zone and serves as
  the intermediate routing point.
- **Destination**: A user's drop-off location (Home, Office, etc.). Has a distance
  from each Delivery Center (Segment 2).

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can complete an express single-item order from listing to
  confirmation in under 2 minutes.
- **SC-002**: A user can complete a multi-vendor cart checkout (3+ items, 2+ zones)
  in under 3 minutes.
- **SC-003**: Price calculations are accurate 100% of the time — the displayed
  total matches the formula `(items total) + (distance × 50 Br)` with zero rounding
  discrepancies.
- **SC-004**: Users can view their full order history and current order status
  without any loading failures on standard mobile connectivity.
- **SC-005**: 90% of users successfully complete their first order without
  contacting support or abandoning mid-flow.
- **SC-006**: Order status updates are reflected in the user dashboard within
  60 seconds of an admin status change.

---

## Assumptions

- Users are already registered and authenticated before accessing the ordering flows;
  authentication/registration is out of scope for this feature.
- Delivery Center coordinates and zone-to-center distances are pre-configured in
  the backend by an admin; this feature reads but does not manage that data.
- The distance unit used throughout the pricing formula is consistent (same unit
  used for zone-to-center and center-to-destination segments).
- Payment verification is manual: an admin reviews the uploaded screenshot and
  advances the order status; no automated payment gateway is involved in this
  feature's scope.
- Users have at least one saved destination (Home or Office) before checking out;
  destination management is assumed to exist or be handled as a dependency.
- The app requires an active internet connection for order submission and status
  retrieval; offline ordering is out of scope.
- All listing types (menu, hotel/restaurant, fruit) share a common data structure
  sufficient to drive the ordering flow (name, image, price, vendor_id).
- The `cart_items[]` payload is a JSON array stored per-session; cart data does
  not persist across app restarts in v1.
