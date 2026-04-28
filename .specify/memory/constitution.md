# Minoo Delivery Constitution

> Governing principles for all `/speckit.*` outputs and development work in this repository.

---

## 1. Engineering Principles

### I. Clarity > Cleverness
- Write code that reads like documentation. Prefer descriptive variable and function names over terse abbreviations.
- Dart idioms (named parameters, null-safety, `const` constructors) are expected — but never sacrifice readability for "clever" Dart tricks.

### II. Simple First
- Start with the simplest implementation that solves the problem.
- Avoid premature abstraction. Extract shared code only after two or more concrete uses.
- YAGNI: do not build features, parameters, or extension points until they are needed.

### III. Correctness
- All business logic must produce correct results before optimizing for performance or aesthetics.
- Null-safety must be enforced project-wide; avoid `!` (bang operator) unless the invariant is documented.
- Use `flutter analyze` with zero warnings as the quality gate before every PR.

### IV. Testability
- New business logic (providers, repositories, services, models) must include unit tests.
- Widget tests are expected for non-trivial UI components.
- Integration tests should cover critical user flows (onboarding → login → home → cart → payment).

---

## 2. Architecture Conventions

### Layer Structure
```
lib/
  main.dart             ← app entry point, routing, theme
  models/               ← plain data classes (no business logic)
  providers/            ← Riverpod providers (state management)
  repositories/         ← data-access layer (API calls, local storage)
  services/             ← cross-cutting utilities (widgets, helpers)
  pages/                ← full-screen UI widgets
  utils/                ← pure utility functions
```

### Dependency Flow
```
Pages → Providers → Repositories → External APIs / Local Storage
                  → Services (cross-cutting)
         Models are shared across all layers
```

- **Pages** depend on providers via `ref.watch` / `ref.read`. Pages must never call repositories directly.
- **Providers** orchestrate business logic and expose state. They may depend on repositories, services, and models.
- **Repositories** handle data access (HTTP, SharedPreferences, etc.). They return model objects and throw typed exceptions.
- **Services** provide cross-cutting, stateless helpers (e.g., widget utilities). They must not hold state.
- **Models** are pure data classes with `fromJson` / `toJson` where applicable. No side effects.

### State Management
- **Riverpod** is the sole state management solution. Do not mix with `StatefulWidget` state for business logic.
- Use `StateNotifierProvider` or `NotifierProvider` for mutable state; `FutureProvider` / `StreamProvider` for async data.
- Providers must be declared at the top level (not inside widgets).

### Backend Access
- All backend communication goes through the **repository layer** using the `http` package.
- If/when Supabase is introduced: Flutter clients must **never** talk to Supabase directly. All Supabase access must go through API routes (server-side), and the Flutter app communicates only with those endpoints.

---

## 3. Security Baseline

- **Validate inputs** at every boundary: form fields in the UI, parameters in repositories, responses from APIs.
- **Least privilege**: request only the permissions the feature actually needs (`permission_handler`).
- **No secrets in code**: API keys, tokens, and credentials must live in environment configuration, never hard-coded.
- **Auth by default**: every new route/page that shows user-specific data must verify authentication state before rendering.

---

## 4. DX Conventions

### File Naming
- Dart files: `snake_case.dart` (e.g., `cart_page.dart`, `delivery_center_model.dart`).
  - Legacy PascalCase files (e.g., `CartPage.dart`) are tolerated but **new** files must use `snake_case`.
- One public class per file. The file name must match the primary class name in snake_case.

### Folder Structure
- Follow the layer structure in §2. Do not create ad-hoc top-level directories without updating this constitution.
- Group related files by feature subdirectory when a feature spans multiple files in the same layer (e.g., `repositories/address/`, `repositories/menu/`).

### Commit Hygiene
- Commits should be atomic: one logical change per commit.
- Commit messages use imperative mood: `Add cart item quantity selector`, not `Added…` or `Adding…`.
- Prefix with area when useful: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`.

### Code Style
- Follow `flutter_lints` rules as configured in `analysis_options.yaml`.
- Use `const` constructors wherever possible.
- Prefer `final` over `var`.
- Use trailing commas for multi-line argument lists (Dart formatter friendly).

---

## 5. Documentation Expectations

- **Spec / Plan / Tasks** files (`.specify/`) are the source of truth for feature work. Code changes that contradict the spec require the spec to be updated first.
- Complex business logic should include a doc comment explaining *why*, not just *what*.
- README.md should remain up to date with setup instructions and project overview.

---

## 6. Performance Expectations

- **Avoid N+1 patterns**: batch API calls where possible; do not fetch related data inside loops.
- **Pagination**: any list endpoint / list UI that could grow unbounded must support pagination or lazy loading.
- **Image caching**: use `cached_network_image` for all remote images (already a dependency).
- **Const widgets**: use `const` constructors to minimize unnecessary widget rebuilds.
- **Minimize rebuilds**: scope Riverpod `ref.watch` to the smallest possible widget to avoid over-rendering.

---

## 7. Repo-Specific Defaults

- **Primary framework**: Flutter (Dart SDK ^3.7.2), targeting Android, iOS, Web, and desktop.
- **State management**: `flutter_riverpod`.
- **HTTP client**: `http` package — no direct `dio` or raw `HttpClient` usage without discussion.
- **Image picking**: `image_picker` — all media selection goes through this package.
- **Local persistence**: `shared_preferences` for simple key-value; evaluate Hive/Drift for structured data if needed.
- **Dev tools**: `device_preview` is available for responsive testing; wrap only in debug mode.
- Prefer concise editor prompts; avoid huge documentation blocks in prompts; keep explanations in chat summaries.

---

## Governance

- This constitution supersedes ad-hoc conventions. All `/speckit.*` outputs must comply.
- Amendments require documentation in this file with a version bump and date.
- Any PR or code review should verify compliance with these principles.

**Version**: 1.0.0 | **Ratified**: 2026-04-03 | **Last Amended**: 2026-04-03
