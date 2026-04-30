<!--
  Sync Impact Report
  ===================
  Version change: 0.0.0 (template) → 1.0.0
  Modified principles: N/A (initial population)
  Added sections:
    - Principle I: Flutter-First Architecture
    - Principle II: Firebase as Backend
    - Principle III: State Management via Riverpod
    - Principle IV: Offline-Resilient & Performance
    - Principle V: Simplicity & YAGNI
    - Section: Technology Stack & Constraints
    - Section: Development Workflow
    - Governance rules
  Removed sections: None
  Templates requiring updates:
    - .specify/templates/plan-template.md ✅ no changes needed
    - .specify/templates/spec-template.md ✅ no changes needed
    - .specify/templates/tasks-template.md ✅ no changes needed
  Follow-up TODOs: None
-->

# Minoo Delivery Constitution

## Core Principles

### I. Flutter-First Architecture

- All client-facing features MUST be implemented in Flutter
  (Dart SDK ^3.7.2) targeting Android and iOS as primary platforms.
- The project MUST follow the established directory layout:
  `lib/models/`, `lib/providers/`, `lib/repositories/`,
  `lib/services/`, `lib/pages/`, `lib/utils/`.
- New features MUST NOT introduce additional frameworks or
  rendering engines (e.g., WebView for core flows) unless
  explicitly approved via a governance amendment.
- Every UI component MUST use Material Design widgets and
  the project's shared theme constants; ad-hoc inline styles
  are prohibited.

### II. Firebase as Backend

- Firebase MUST remain the sole backend-as-a-service provider
  for authentication, Firestore data persistence, Cloud Storage
  (payment screenshots, menu images), and push notifications.
- All Firestore collections MUST have documented schemas in
  `lib/models/` as Dart data classes with `fromJson`/`toJson`
  serialization.
- Security rules for Firestore and Cloud Storage MUST be
  version-controlled alongside application code and reviewed
  before deployment.
- Direct Firestore calls from UI widgets are prohibited;
  all data access MUST flow through the repository layer
  (`lib/repositories/`).

### III. State Management via Riverpod

- Riverpod (`flutter_riverpod`) MUST be the sole state
  management solution; mixing with setState-heavy patterns,
  BLoC, or Provider is prohibited.
- Providers MUST reside in `lib/providers/` and be organized
  by domain (e.g., `order_providers.dart`, `cart_providers.dart`).
- Business logic MUST live in providers or services—never
  directly inside widget `build()` methods.
- Every provider that performs async work MUST expose loading,
  error, and data states via `AsyncValue` or equivalent.

### IV. Offline-Resilient & Performance

- The app MUST cache critical read-only data (menus, vendor
  listings, delivery centers) using `cached_network_image` for
  images and `shared_preferences` for lightweight key-value
  data so users can browse content without connectivity.
- Write operations (placing orders, uploading payment
  screenshots) MAY require connectivity but MUST surface a
  clear, user-friendly error when the network is unavailable.
- UI frames MUST target 60 fps on mid-range devices; heavy
  computations (distance calculations, cart aggregation) MUST
  run outside the main isolate or use `compute()`.
- Image assets MUST be optimized before committing; maximum
  individual asset size is 500 KB.

### V. Simplicity & YAGNI

- Features MUST start with the simplest viable implementation;
  premature abstractions are prohibited.
- No code MUST be added speculatively—every line MUST trace
  back to a user story or explicit requirement in the SRS.
- When two approaches have comparable outcomes, the one with
  fewer moving parts MUST be chosen.
- Dependencies MUST NOT be added without justification;
  the current dependency set (see `pubspec.yaml`) is the
  baseline and additions require documented rationale.

## Technology Stack & Constraints

- **Language**: Dart (SDK ^3.7.2)
- **Framework**: Flutter (uses-material-design: true)
- **Backend**: Firebase (Firestore, Auth, Cloud Storage)
- **State Management**: flutter_riverpod
- **HTTP**: `http` package for any REST calls outside Firebase
- **Image Handling**: `cached_network_image`, `image_picker`
- **Local Storage**: `shared_preferences`
- **Permissions**: `permission_handler`
- **Dev Tooling**: `device_preview` for responsive testing
- **Target Platforms**: Android (primary), iOS (secondary)
- **Minimum Flutter version**: Stable channel, SDK ^3.7.2
- **Naming Convention**: snake_case for files and directories,
  PascalCase for classes, camelCase for variables/methods
- **Pricing Model**: Hub-and-Spoke logistics at 50 Br per
  distance unit (Zone → Center → Destination)
- **Payment**: Screenshot-based manual verification by admin

## Development Workflow

- **Branching**: Feature branches named per spec-kit
  convention (`###-feature-name`); all work branches from
  and merges back to `main`.
- **Commit Discipline**: Atomic commits after each logical
  unit of work; commit messages follow
  `type: short description` format
  (types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`).
- **Code Review**: Every change to `lib/` or Firebase rules
  MUST be reviewed before merge; self-merges are prohibited
  for production-impacting code.
- **Testing**: Widget tests and unit tests for business logic
  are encouraged and MUST be placed in `test/`. Integration
  tests for critical flows (ordering, cart checkout) MUST
  exist before a feature is considered complete.
- **Linting**: `flutter analyze` MUST report zero errors and
  zero warnings before any merge; the project's
  `analysis_options.yaml` is the source of truth for lint rules.
- **Documentation**: Every new model, service, or provider
  MUST include a doc comment (`///`) explaining its purpose.

## Governance

- This constitution supersedes all ad-hoc practices and
  informal conventions. In case of conflict, the constitution
  wins.
- Amendments MUST be proposed via the `/speckit-constitution`
  command, include a version bump rationale, and update all
  dependent templates listed in the Sync Impact Report.
- Versioning follows Semantic Versioning:
  - **MAJOR**: Principle removal or backward-incompatible
    redefinition.
  - **MINOR**: New principle, section, or material expansion.
  - **PATCH**: Clarifications, wording, typo fixes.
- Compliance reviews MUST occur at the start of every new
  feature specification (`/speckit-plan` Constitution Check).
- The `AGENTS.md` file at the project root MUST direct all
  agents to read the current plan for technology and
  structural context.

**Version**: 1.0.0 | **Ratified**: 2026-04-30 | **Last Amended**: 2026-04-30
