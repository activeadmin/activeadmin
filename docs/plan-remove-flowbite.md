# Plan: Remove Flowbite Dependency

## Background

### Why Flowbite was adopted

ActiveAdmin 4 was rewritten from Sass to Tailwind CSS. Flowbite was introduced to provide:

1. **Form reset / base styles (plugin.js)** — A "global reset" for form elements (inputs, selects, checkboxes, radios, file inputs) to look decent out of the box with Tailwind. This was originally based on `@tailwindcss/forms` / Flowbite's form plugin, then customized and inlined directly into ActiveAdmin's own `plugin.js`.
2. **Dropdown component** — Positioned dropdown menus powered by Popper.js, triggered via `data-dropdown-toggle` attributes. Used in the **user menu** (site header) and the **batch actions dropdown**.
3. **Drawer component** — A slide-in side panel for the **mobile navigation menu**, triggered via `data-drawer-target` / `data-drawer-show` attributes.
4. **Modal component** — Used for **batch action custom forms** (e.g., the starred batch action example), triggered via `data-modal-target` / `data-modal-show` / `data-modal-hide` attributes.
5. **Tailwind content scanning** — `vendor/javascript/flowbite.js` is listed in the `content` array of the generated Tailwind config so that Tailwind picks up class names used inside Flowbite's JS (datepicker, etc.).

### Why Flowbite 4 is a no-go

PR #8938 attempted to upgrade from Flowbite 3.1.2 to 4.0.1. The findings:

- **CSS theme variables required**: Flowbite v4 changed from hardcoded Tailwind classes (`bg-gray-900/50`) to CSS custom properties (`bg-dark-backdrop/70` relying on `--color-dark-backdrop`). Without importing Flowbite's theme CSS, modals and drawers lose their backdrop.
- **Forced font-family**: The default Flowbite v4 theme forces Inter font via `--font-sans` / `--font-body`, and advises importing from Google Fonts CDN — an external dependency that slows down the admin and is unacceptable for many deployments.
- **Subpar JavaScript**: The Flowbite JS implementation quality has not improved — it still uses a global instance registry pattern, makes it hard to work with Turbo/SPA patterns, and carries a large bundle (~80KB min) for components we barely use.

### Current state of Flowbite usage

ActiveAdmin already does most of the heavy lifting itself. Flowbite is used for exactly **3 JS components** (dropdown, drawer, modal) plus the vendored JS serves as a Tailwind content source for datepicker classes embedded inside Flowbite.

## What Flowbite provides (and replacements)

| Flowbite feature | Where used | Replacement strategy |
|---|---|---|
| **Form reset / base styles** | `plugin.js` | **Already done.** `plugin.js` contains a fully self-contained form reset. No Flowbite code is used for this. The `mini-svg-data-uri` utility is inlined. |
| **Dropdown** (Popper.js) | User menu (`_site_header.html.erb`), Batch actions dropdown (`_batch_actions_dropdown.html.erb`) | Replace with a lightweight custom dropdown using `@floating-ui/dom` (~4KB) or pure CSS/JS. See details below. |
| **Drawer** | Mobile nav menu (`_site_header.html.erb` → `#main-menu`) | Replace with a custom drawer using CSS transitions + a small JS controller. See details below. |
| **Modal** | Batch action custom forms (user-provided partials) | Replace with a custom modal using CSS + a small JS controller. Provide a documented API for users. See details below. |
| **Datepicker** | Embedded inside `flowbite.js` (the `flowbite-datepicker` sub-dependency) | Not actively used by ActiveAdmin core. Remove from content scanning. If users need a datepicker, it can be a separate add-on. |
| **Content scanning** | `tailwind.config.js` template includes `flowbite.js` in `content` | Remove the `flowbite.js` line from the content array. Classes in `plugin.js` and ERB templates are already scanned independently. |

## Detailed replacement plan

### Phase 1: Implement replacement JS components

Create small, focused JS modules in `app/javascript/active_admin/features/`:

#### 1a. Dropdown (`dropdown.js`)

**Current behavior**: Flowbite's `data-dropdown-toggle` creates a Popper.js-positioned dropdown, shows/hides on click, closes on click-outside and Escape.

**Replacement options** (in order of preference):

1. **`@floating-ui/dom`** (~4KB gzipped) — The successor to Popper.js. Provides `computePosition()` and auto-placement. Import via importmap. Create a small event-delegation script:
   - Listen for click on `[data-aa-dropdown-toggle]`
   - Position the target element using Floating UI
   - Toggle visibility class (`hidden`)
   - Close on click-outside and Escape
   - Support `data-aa-dropdown-placement` and `data-aa-dropdown-offset-distance`

2. **CSS Anchor Positioning** — A future option (Chrome 125+, not yet in Firefox/Safari). Not viable today.

3. **`popover` attribute + CSS `anchor()`** — HTML `popover` is supported in all modern browsers. Combined with basic JS for positioning, this could work without any library. Worth evaluating.

**Recommended**: Option 1 (`@floating-ui/dom`) for robust positioning. Keep the API similar to current usage, just rename `data-dropdown-toggle` → `data-aa-dropdown-toggle` (namespaced to avoid conflicts).

**Files to change**:
- Create `app/javascript/active_admin/features/dropdown.js`
- Update `app/views/active_admin/_site_header.html.erb` (data attributes)
- Update `app/views/active_admin/resource/_batch_actions_dropdown.html.erb` (data attributes)
- Update `app/javascript/active_admin.js` (add import)
- Add `@floating-ui/dom` to `package.json` dependencies and `config/importmap.rb`

#### 1b. Drawer (`drawer.js`)

**Current behavior**: Flowbite's `data-drawer-target` / `data-drawer-show` slides in a panel from the left, adds a backdrop overlay, prevents body scrolling, and allows dismissal via Escape or clicking the backdrop.

**Replacement**: Pure CSS transitions + a small JS controller (no library needed):
- Toggle `transform: translateX(-100%)` ↔ `translateX(0)` on the drawer
- Manage a backdrop `<div>` with `bg-gray-900/50 fixed inset-0 z-30`
- Toggle `overflow-hidden` on `<body>`
- Listen for Escape key and backdrop click to close
- Support `aria-hidden`, `aria-modal`, `role="dialog"` toggling

**Files to change**:
- Create `app/javascript/active_admin/features/drawer.js`
- Update `app/views/active_admin/_site_header.html.erb` (data attributes)
- Update `app/javascript/active_admin.js` (add import)

#### 1c. Modal (`modal.js`)

**Current behavior**: Flowbite's `data-modal-target` / `data-modal-show` / `data-modal-hide` shows/hides a centered modal with backdrop, closes on Escape and click-outside.

**Replacement**: Pure CSS + a small JS controller (no library needed):
- Toggle `hidden` / `flex` classes on the modal wrapper
- Manage a backdrop element
- Toggle `overflow-hidden` on `<body>`
- Listen for Escape and click-outside to close
- Support `data-aa-modal-show`, `data-aa-modal-hide`, `data-aa-modal-toggle` attributes

**Files to change**:
- Create `app/javascript/active_admin/features/modal.js`
- Update `app/javascript/active_admin.js` (add import)
- Update documentation in `docs/9-batch-actions.md` (modal example)
- Update `UPGRADING.md` (batch action modal data attributes)
- Update test templates and features

### Phase 2: Remove Flowbite dependency

#### 2a. Remove from JavaScript entry point
- Remove `import "flowbite"` from `app/javascript/active_admin.js`

#### 2b. Remove vendored file
- Delete `vendor/javascript/flowbite.js`

#### 2c. Remove from package.json
- Remove `"flowbite": "3.1.2"` from `dependencies`
- Run `yarn install` to update lockfile

#### 2d. Remove from importmap
- Remove the `pin "flowbite"` line from `config/importmap.rb`

#### 2e. Remove from Tailwind config template
- Remove `${activeAdminPath}/vendor/javascript/flowbite.js` from the `content` array in `lib/generators/active_admin/assets/templates/tailwind.config.js`

#### 2f. Remove vendor task
- Remove the flowbite copy logic from `tasks/dependencies.rake`

#### 2g. Remove from rollup external
- `rollup.config.js` externalizes `packageJson.dependencies` — once flowbite is removed from `package.json`, this is automatic.

### Phase 3: Update documentation and references

- Update `README.md` — remove Flowbite from the credits/dependencies list
- Update `UPGRADING.md` — add a migration section explaining data attribute changes
- Update `.github/copilot-instructions.md` — remove Flowbite from the technology stack
- Update `docs/9-batch-actions.md` — update modal example with new data attributes
- Update `CHANGELOG.md` — document the removal

### Phase 4: Update tests

- Update `spec/support/templates/views/admin/posts/_starred_batch_action_form.html.erb` — new modal data attributes
- Update `spec/support/templates_with_data/admin/posts.rb` — new data attributes
- Update `features/index/batch_actions.feature` — new data attributes
- Update `tasks/test_application.rb` — remove flowbite vendor comment if still relevant
- Run full test suite: `bin/rake`

## New dependency: `@floating-ui/dom`

| Property | Value |
|---|---|
| Package | `@floating-ui/dom` |
| Size | ~4KB gzipped (vs ~80KB for Flowbite) |
| License | MIT |
| Purpose | Dropdown/popover positioning only |
| Alternative | Could be avoided entirely if dropdowns are positioned via pure CSS (e.g., `position: absolute` relative to parent), accepting less precise edge-case positioning. |

**Decision needed**: Is the `@floating-ui/dom` dependency acceptable, or should we go with pure CSS-positioned dropdowns? The user menu and batch actions dropdown are simple enough that `absolute` + `right-0` / `left-0` positioning may suffice without Floating UI.

If pure CSS positioning is acceptable:
- No new JS dependency at all
- Dropdown opens below the trigger, aligned to start/end
- No auto-flip when near viewport edges (acceptable for an admin panel)

## Summary of data attribute changes

| Current (Flowbite) | New (ActiveAdmin) | Component |
|---|---|---|
| `data-dropdown-toggle` | `data-aa-dropdown-toggle` | Dropdown |
| `data-dropdown-placement` | `data-aa-dropdown-placement` | Dropdown |
| `data-dropdown-offset-distance` | `data-aa-dropdown-offset` | Dropdown |
| `data-drawer-target` | `data-aa-drawer-target` | Drawer |
| `data-drawer-show` | `data-aa-drawer-show` | Drawer |
| `data-modal-target` | `data-aa-modal-target` | Modal |
| `data-modal-show` | `data-aa-modal-show` | Modal |
| `data-modal-hide` | `data-aa-modal-hide` | Modal |

> **Note**: Namespacing with `aa-` prevents conflicts with other libraries users may have. Alternatively, keep short names without prefix — decision needed.

## Risk assessment

| Risk | Likelihood | Mitigation |
|---|---|---|
| Users rely on Flowbite data attributes in custom partials | Medium | Document migration path in UPGRADING.md. Consider a deprecation period with both old and new attributes. |
| Dropdown positioning edge cases | Low | Admin panels are usually used on desktop; simple absolute positioning is sufficient. |
| Mobile drawer behavior regression | Low | Well-tested CSS transitions; drawer behavior is straightforward. |
| Modal accessibility regression | Medium | Ensure focus trapping, Escape key handling, and ARIA attributes match current behavior. |
| Breaking change for users who `import "flowbite"` in their own JS | Low | This is their own import; removing our dependency doesn't affect their code if they install flowbite themselves. |

## Estimated scope

- 3 new JS files (~50-80 lines each)
- ~10 file modifications (templates, configs, docs)
- ~5 file deletions (vendor, related config lines)
- Net reduction: ~80KB of vendored JS removed, ~0-4KB added
