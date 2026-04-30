# Tasks: Minoo Delivery Ordering System

**Input**: Design documents from `specs/001-ordering-system/`
**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ ✅

**Tests**: Not requested — no test tasks generated.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story this task belongs to (US1, US2, US3)
- Exact file paths included in every task description

## Path Conventions

- Flutter project root: `minoo_deleivery/lib/`
- Models: `minoo_deleivery/lib/models/`
- Services: `minoo_deleivery/lib/services/`
- Repositories: `minoo_deleivery/lib/repositories/`
- Providers: `minoo_deleivery/lib/providers/`
- Pages: `minoo_deleivery/lib/pages/`

---

## Phase 1: Setup

**Purpose**: Establish new directory structure and route scaffolding shared by all stories.

- [ ] T001 Create directory `minoo_deleivery/lib/services/order/` (new service domain)
- [ ] T002 Create directory `minoo_deleivery/lib/repositories/order/` (new repository domain)
- [ ] T003 Create directory `minoo_deleivery/lib/providers/order/` (new provider domain)
- [ ] T004 Add three new named routes to `minoo_deleivery/lib/main.dart`: `'/express-checkout'`, `'/orders'`, `'/order-detail'` (stub pages acceptable at this stage)

**Checkpoint**: Directory skeleton in place; app still runs with no regressions.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core models and API service layer that ALL user stories depend on.
Must be complete before any user story implementation begins.

**⚠️ CRITICAL**: No user story work begins until this phase is complete.

- [ ] T005 [P] Create `OrderType` and `OrderStatus` enums and `Order` Dart class with `fromJson`/`toJson` in `minoo_deleivery/lib/models/order_model.dart` (fields: id, orderType, status, deliveryCenterId, deliveryCenterName, destinationId, destinationName, itemsSubtotal, deliveryPrice, totalPrice, paymentScreenshotUrl, items, singleItem, createdAt)
- [ ] T006 [P] Create `OrderItem` Dart class with `fromJson`/`toJson` in `minoo_deleivery/lib/models/order_item_model.dart` (fields: id, orderId, menuId, menuName, menuImageUrl, vendorId, unitPrice, quantity, lineTotal)
- [ ] T007 Create `OrderApiService` in `minoo_deleivery/lib/services/order/order_api_service.dart` with two methods: `submitOrder({required String orderType, required Map<String, dynamic> fields, required XFile screenshot})` → POST multipart to `https://minoodelivery.com/orders` returning `Order`; and `fetchOrders({required int userId})` → GET `https://minoodelivery.com/orders?user_id={userId}` returning `List<Order>` (depends on T005, T006)
- [ ] T008 Create `OrderRepository` in `minoo_deleivery/lib/repositories/order/order_repository.dart` wrapping `OrderApiService` with typed methods `submitOrder(...)` and `fetchOrders(int userId)` (depends on T007)

**Checkpoint**: Foundation ready — models parse correctly, API service compiles, repository wired. Run `flutter analyze` → zero errors.

---

## Phase 3: User Story 1 — Express Single-Item Order (Priority: P1) 🎯 MVP

**Goal**: User taps "Order Now" on any listing, picks center + destination, sees calculated price, uploads payment screenshot, order created with status Pending.

**Independent Test**: Follow quickstart.md §"Validate User Story 1" — place a single express order end-to-end and confirm it appears in order history as Pending / Single Item.

### Implementation for User Story 1

- [ ] T009 [P] [US1] Create `orderRepositoryProvider` and `orderApiServiceProvider` Riverpod providers in `minoo_deleivery/lib/providers/order/order_provider.dart` (mirrors existing `menuRepositoryProvider` pattern; depends on T008)
- [ ] T010 [P] [US1] Create `ExpressOrderNotifier extends AsyncNotifier<Order?>` in `minoo_deleivery/lib/providers/order/order_provider.dart` with method `submitExpressOrder({required MenuItem item, required int quantity, required DeliveryCenter center, required Destination destination, required XFile screenshot})` — builds payload per `contracts/order-submission.md` (single type), calls repository, returns `Order` (depends on T009)
- [ ] T011 [US1] Create `ExpressCheckoutPage` as a `ConsumerStatefulWidget` in `minoo_deleivery/lib/pages/express_checkout.dart` — accepts `MenuItem` and `quantity` as constructor args; shows item name + image, `deliveryCentersProvider` dropdown, `destinationsProvider.family` dropdown (filtered by selected center), calculated total price display (`itemPrice × qty + distance × 50`), and "Check Out" button that opens payment dialog (depends on T009, T010; reuses existing `deliveryCentersProvider`, `destinationsProvider`, `distanceProvider`, `showPaymentDialog`)
- [ ] T012 [US1] Modify `minoo_deleivery/lib/pages/payment_Proof.dart`: add `XFile? pickedFile` state; store the `XFile` (not just the name) when image picked; expose it via a callback `onFileSelected(XFile file)` parameter so callers can retrieve the file for upload (depends on T011)
- [ ] T013 [US1] Wire the "Submit" button in `ExpressCheckoutPage` (`minoo_deleivery/lib/pages/express_checkout.dart`) to call `ExpressOrderNotifier.submitExpressOrder(...)` with the picked `XFile`, show a loading indicator while `AsyncValue.loading`, show success snackbar + navigate to `/orders` on success, show error snackbar on failure (depends on T011, T012)
- [ ] T014 [US1] Modify `minoo_deleivery/lib/pages/details.dart`: add an "Order Now" `ElevatedButton` below the existing "Add to Cart" button; on tap, `Navigator.push` to `ExpressCheckoutPage(item: food, quantity: quantity)` (depends on T011)
- [ ] T015 [US1] Register `ExpressCheckoutPage` route `'/express-checkout'` in `minoo_deleivery/lib/main.dart` with proper argument passing via `ModalRoute.of(context)!.settings.arguments` (depends on T011, T014)

**Checkpoint**: US1 fully functional. Tap "Order Now" on any listing → complete flow → order in dashboard as Pending. Run `flutter analyze` → zero errors.

---

## Phase 4: User Story 2 — Cart Multi-Vendor Order (Priority: P2)

**Goal**: User adds items from multiple vendors to cart, places single order with one payment screenshot, cart clears on success, order appears as Cart Order.

**Independent Test**: Follow quickstart.md §"Validate User Story 2" — add 2 items from different vendors, complete cart checkout, verify Cart Order badge and expandable item list in history.

### Implementation for User Story 2

- [ ] T016 [P] [US2] Create `CartOrderNotifier extends AsyncNotifier<Order?>` in `minoo_deleivery/lib/providers/order/order_provider.dart` with method `submitCartOrder({required List<CartItem> cartItems, required DeliveryCenter center, required Destination destination, required XFile screenshot})` — builds `items` JSON array from cart, calls `orderRepository.submitOrder` with `order_type: 'cart'`, on success calls `ref.read(cartProvider.notifier).clearCart()` (depends on T008, T009)
- [ ] T017 [US2] Modify `minoo_deleivery/lib/pages/payment_Proof.dart`: accept an `onSubmit(XFile file)` async callback parameter instead of the current `TODO`; call `onSubmit` when user taps Submit with a valid file; show `CircularProgressIndicator` while awaiting; close dialog on completion (depends on T012, T016)
- [ ] T018 [US2] Modify `minoo_deleivery/lib/pages/PriceDetails.dart` (`CheckoutSummaryPage`): replace the current `showPaymentDialog(context)` call with a call that passes an `onSubmit` callback wired to `CartOrderNotifier.submitCartOrder(...)` using `ref.read`; show loading overlay during submission; on success navigate to `/orders` and show snackbar "Order placed!"; on error show snackbar with error message (depends on T016, T017)

**Checkpoint**: US1 and US2 both independently functional. Cart flow places order, clears cart, navigates to history. Run `flutter analyze` → zero errors.

---

## Phase 5: User Story 3 — Order Status Tracking (Priority: P3)

**Goal**: User views full order history with type badges, delivery info, and live status labels (Pending → Processing → Out for Delivery → Completed).

**Independent Test**: Follow quickstart.md §"Validate User Story 3" — complete any order, open Order History, verify badge + status; after admin status change, pull-to-refresh shows updated status.

### Implementation for User Story 3

- [ ] T019 [P] [US3] Create `orderHistoryProvider` as `FutureProvider<List<Order>>` in `minoo_deleivery/lib/providers/order/order_history_provider.dart` — calls `orderRepository.fetchOrders(userId)` where `userId` is read from `shared_preferences` (key: `user_id`); follows existing `FutureProvider` pattern from `address_providers.dart` (depends on T008)
- [ ] T020 [P] [US3] Create `OrderHistoryPage` as a `ConsumerWidget` in `minoo_deleivery/lib/pages/order_history.dart` — watches `orderHistoryProvider`; shows `AsyncValue.when(data, loading, error)`; data state renders `ListView` of order cards; each card shows: type badge chip (Single Item amber / Cart Order blue), Delivery Center → Destination, total price, status label with color (pending=amber, processing=blue, out_for_delivery=purple, completed=green); tapping a cart order navigates to `OrderDetailPage`; includes `RefreshIndicator` for pull-to-refresh that calls `ref.refresh(orderHistoryProvider)` (depends on T019)
- [ ] T021 [US3] Create `OrderDetailPage` as a `ConsumerWidget` in `minoo_deleivery/lib/pages/order_detail.dart` — accepts `Order` as constructor argument; shows order summary header (center, destination, total, status); renders expandable `ExpansionTile` listing all `OrderItem` entries with `CachedNetworkImage` thumbnail, item name, quantity × price; shows payment screenshot thumbnail if `paymentScreenshotUrl` is non-null (depends on T020)
- [ ] T022 [US3] Register `OrderHistoryPage` at route `'/orders'` and `OrderDetailPage` at route `'/order-detail'` in `minoo_deleivery/lib/main.dart`; add an order history icon button to the `Home` page app bar (`minoo_deleivery/lib/pages/home.dart`) that navigates to `'/orders'` (depends on T020, T021)

**Checkpoint**: All three user stories independently functional. Run `flutter analyze` → zero errors. Full quickstart.md walkthrough passes.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Quality, consistency, and UX improvements across all stories.

- [ ] T023 Add `///` doc comments to all new Dart classes and public methods: `order_model.dart`, `order_item_model.dart`, `order_api_service.dart`, `order_repository.dart`, `order_provider.dart`, `order_history_provider.dart` (constitution: documentation requirement)
- [ ] T024 [P] Audit all new pages for empty/error states: `ExpressCheckoutPage` (no centers available), `OrderHistoryPage` (empty list), `OrderDetailPage` (no items); add user-friendly empty-state widgets with descriptive messages
- [ ] T025 [P] Ensure all `CachedNetworkImage` usages in new pages (`express_checkout.dart`, `order_history.dart`, `order_detail.dart`) have `placeholder` and `errorWidget` handlers consistent with existing pages
- [ ] T026 Run `flutter analyze` across full project; fix any new warnings or info-level issues introduced by this feature
- [ ] T027 [P] Update `specs/001-ordering-system/quickstart.md` if any implementation details differ from the plan (e.g., actual route names, actual API field names discovered during implementation)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 2 — MVP increment
- **US2 (Phase 4)**: Depends on Phase 2 — can run after US1 or in parallel
- **US3 (Phase 5)**: Depends on Phase 2 — can run after US1/US2 or in parallel
- **Polish (Phase 6)**: Depends on all desired stories being complete

### User Story Dependencies

- **US1 (P1)**: Depends on Foundational only. No dependency on US2 or US3.
- **US2 (P2)**: Depends on Foundational only. Shares `OrderApiService` with US1.
- **US3 (P3)**: Depends on Foundational only. Shares `OrderRepository` and `orderHistoryProvider`.

### Within Each User Story

- Models (T005, T006) → Service (T007) → Repository (T008) → Providers → Pages
- Providers before pages that consume them
- Page modifications after the new page they link to exists

### Parallel Opportunities

**Phase 2** (run together):
```
T005 — order_model.dart
T006 — order_item_model.dart
```

**Phase 3** (run together after T008):
```
T009 — orderRepositoryProvider
T010 — ExpressOrderNotifier
```
Then:
```
T011 → T012 → T013 (sequential, same page chain)
T014 — details.dart modification (independent of T011–T013)
```

**Phase 4** (run together after T008):
```
T016 — CartOrderNotifier (independent of T011–T015)
```

**Phase 5** (run together after T008):
```
T019 — orderHistoryProvider
T020 — OrderHistoryPage
```

**Phase 6** (all [P] tasks run together):
```
T023, T024, T025, T026, T027
```

---

## Implementation Strategy

### MVP First (US1 Only — Express Order)

1. Complete Phase 1 (Setup)
2. Complete Phase 2 (Foundational — T005–T008)
3. Complete Phase 3 (US1 — T009–T015)
4. **STOP and VALIDATE**: Run quickstart.md §US1 validation
5. Run `flutter analyze` → zero errors
6. Demo: Express order placed, visible in history as Pending

### Incremental Delivery

1. Setup + Foundational → Foundation ready (T001–T008)
2. Add US1 → Express Order MVP (T009–T015) → Validate → Demo
3. Add US2 → Cart Order (T016–T018) → Validate → Demo
4. Add US3 → Order History (T019–T022) → Validate → Demo
5. Polish → Production-ready (T023–T027)

---

## Notes

- `[P]` = different files, safe to run in parallel
- `[USn]` = maps task to user story for traceability
- All new files must pass `flutter analyze` before moving to the next task
- `clearCart()` already exists in `CartNotifier` — call it, don't rewrite it
- `showPaymentDialog` refactor (T012, T017) is additive — existing behavior preserved
- The `TODO: Upload file to server` comment in `payment_Proof.dart` is the primary gap being closed by T012 and T017
