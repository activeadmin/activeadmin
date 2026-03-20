# Upgrading to v4

ActiveAdmin v4 uses Tailwind CSS v4. It has **mobile web, dark mode and RTL support** with a default theme that can be customized through partials and CSS. This release assumes `cssbundling-rails` and `importmap-rails` are installed and configured in the host app. Partials can be modified to include a different asset library, e.g. shakapacker.

::: warning
There is **no sortable functionality for has-many forms** in this release. If you rely on it, **do not upgrade**. We are [open to community proposals](https://github.com/activeadmin/activeadmin/discussions/new?category=ideas). The add/remove functionality for has-many forms remains supported.
:::

## From v3

These instructions assume `cssbundling-rails` and `importmap-rails` are already installed and their install commands have been run in your app. If not, please do so before continuing.

**1.** Update your `Gemfile` and install:

```ruby
gem "activeadmin", "4.0.0.beta22"
```

```sh
gem install activeadmin --pre
```

**2.** Regenerate the assets:

```sh
rails generate active_admin:assets
```

**3.** Add the npm package and update the `build:css` script:

```sh
yarn add @activeadmin/activeadmin@4.0.0-beta22
npm pkg set scripts.build:css="npx @tailwindcss/cli -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify"
```

If you are already using Tailwind in your app, chain the command to your existing `build:css`, e.g. `"npx @tailwindcss/cli ... && npx @tailwindcss/cli ..."`.

**4.** Remove deleted configs from `config/initializers/active_admin.rb`:

```ruby
# Remove these — they are no longer supported
site_title_link
site_title_image
logout_link_method
favicon
meta_tags
meta_tags_for_logged_out_pages
register_stylesheet
register_javascript
head
footer
use_webpacker
```

These can now be customized more naturally through partials.

**5.** Copy view partials to your app for customization:

```sh
rails g active_admin:views
```

::: info
Templates can and will change across releases. There are additional partials that can be copied but they are considered private — you will need to keep those up to date per release.
:::

::: warning
If your project has copied any ActiveAdmin, Devise, or Kaminari templates from earlier releases, those must be updated from this release to avoid potential errors. Path helpers in Devise templates may require using the `main_app` proxy. The Kaminari templates have moved to `app/views/active_admin/kaminari`.
:::

With the setup complete, review the Breaking Changes section below and resolve any that impact your integration.

## Upgrading from an earlier 4.x beta

### 4.0.0.beta16 template changes

There were important template changes in 4.0.0.beta16. See [PR #8727](https://github.com/activeadmin/activeadmin/pull/8727) for details.

- `_site_header.html.erb`: main container class changed from `sticky` to `fixed`.
- `active_admin.html.erb`: now includes the `pt-16` utility class.

### 4.0.0.beta19 — Tailwind CSS v4 migration

Update your `active_admin.css`:

```diff
-@tailwind base;
-@tailwind components;
-@tailwind utilities;
+@import "tailwindcss";
+
+@config "../../../tailwind-active_admin.config.js";
```

Update the `build:css` script in your `package.json`:

```diff
-"build:css": "tailwindcss -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify -c tailwind-active_admin.config.js"
+"build:css": "npx @tailwindcss/cli -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify"
```

You may see the following warning:

```
[MODULE_TYPELESS_PACKAGE_JSON] Warning: Module type of tailwind-active_admin.config.js is not specified
and it doesn't parse as CommonJS. Reparsing as ES module because module syntax was detected.
```

To fix it, either rename `tailwind-active_admin.config.js` to `tailwind-active_admin.config.mjs`, or add `"type": "module"` to your `package.json`.

## Breaking Changes

- **jQuery and jQuery UI have been removed.**

- **The `columns` component has been removed.** Use `div`s with Tailwind classes for modern, responsive layout.

  <details>
  <summary>Columns migration alternative</summary>

  If you only need equal-width columns, this component restores that functionality:

  ```ruby
  # app/admin/components/columns.rb
  class Columns < ActiveAdmin::Component
    builder_method :columns

    def build(*args)
      super
      add_class "grid auto-cols-fr grid-flow-col gap-4 mb-4"
    end

    def column(*args, &block)
      insert_tag Arbre::HTML::Div, *args, &block
    end
  end
  ```

  Using Tailwind modifiers you can further customize the number of columns for responsive/mobile support.
  </details>

- **The `tabs` component has been removed.** Use a CSS based or third party alternative.

- **Replace `default_main_content` with `render "show_default"`.**

  <details>
  <summary>Show default alternative</summary>

  If you used the block form `default_main_content do ... end`, replace with:

  ```ruby
  attributes_table_for(resource) do
    rows *active_admin_config.resource_columns
    row :a
    row :b
    # ...
  end
  active_admin_comments_for(resource) if active_admin_config.comments?
  ```
  </details>

- **Replace `as: :datepicker`** with Formtastic's `as: :date_picker` for the native HTML date input.

- **Replace `active_admin_comments`** with `active_admin_comments_for(resource)`.

- **In a sidebar section, replace `attributes_table`** with `attributes_table_for(resource)`.

- **`IndexAsBlog`, `IndexAsBlock`, and `IndexAsGrid` have been removed.** Create your own [custom index](3-index-pages/custom-index) components — custom index views remain supported.

- **Batch Actions Form DSL has been replaced with Rails partial support.**

  <details>
  <summary>Batch action partial example</summary>

  Set a partial name and HTML data attributes to trigger a modal. Flowbite is included by default, but any modal library triggered via data attributes works:

  ```ruby
  batch_action(
    :mark_published,
    partial: "mark_published_batch_action",
    link_html_options: {
      "data-modal-target": "mark-published-modal",
      "data-modal-show": "mark-published-modal"
    }
  ) do |ids, inputs|
    # ...
  end
  ```

  In `app/views/admin/posts/`, create `_mark_published_batch_action.html.erb`. The form must have an empty `data-batch-action-form` attribute:

  ```erb
  <div id="mark-published-modal" class="hidden fixed top-0 ..." aria-hidden="true" ...>
    <!-- modal content -->
    <%= form_tag false, "data-batch-action-form": "" do %>
      <!-- your inputs here -->
    <% end %>
  </div>
  ```

  When the form is submitted, it posts and runs your batch action block with the supplied form data, functioning as before.
  </details>

- **Deeply nested submenus have been reverted.** Only one level of nesting is supported, e.g. `menu parent: "Administrative"`.

- **`Panel#header_action` has been removed.**

- **`index_column` has been removed** from the index table.

  <details>
  <summary>Re-implementation</summary>

  ```ruby
  column "Number", sortable: false do |item|
    @collection.offset_value + @collection.index(item) + 1
  end
  ```
  </details>

- **`row 'name'` in `attributes_table`** now prints the header text as-is. For a localized lookup with titleized fallback, use `row :name` instead (matching `column 'name'` behavior in `TableFor`).

### Resource named methods

Resource named methods (e.g. `post`, `posts`) used in `action_item` and `sidebar` blocks will now raise an error. Use `resource` or `collection` instead:

```ruby
# Before
action_item :view, if: ->{ post.published? } do link_to(resource) end
sidebar :author, if: ->{ post.published? }

# After
action_item :view, if: ->{ resource.published? } do link_to(resource) end
sidebar :author, if: ->{ resource.published? }
```

`@post` can also be used, but make sure to call `authorize!` on it when using the authorization feature.

## Visual Changes

- Sidebar contents and the show resource `attributes_table` are no longer wrapped in a panel and can be fully customized.
- Links in custom `action_item`s have no default styles. Apply your own or use the library's `action-item-button` class.
- The `actions dropdown: true` option on the index table is ignored, reverting to the original output.
- An `Arbre::Component` no longer adds a CSS class based on the component class name by default.
- Typographic elements (other than links in main content) [are not styled by default](https://tailwindcss.com/docs/preflight). Use the `@tailwindcss/typography` plugin or apply your own CSS.

## Enhancements

- Dark mode support.
- Mobile web support. For responsive `table_for`s, wrap them in a `div` with `overflow-x-auto`.
- Customizable admin theme — main menu, user menu, and more, all through partials.
- RTL support improved using CSS Logical Properties.
- Kaminari templates consolidated into a single customizable set under `app/views/active_admin/kaminari`.
- Datepickers now use the native HTML date input. Apply a custom datepicker of your choosing.
- `status_tag` now uses unique labels for `false` and `nil` values.
- `table_for`, `status_tag`, etc. now use data attributes instead of classes for metadata (status, sort direction, column, etc.).
- Arbre builder methods reduced to the minimum to avoid clashes with HTML elements like `header`, `footer`, `columns`, etc.
- The [app-helpers-not-reloading bug has been fixed](https://github.com/activeadmin/activeadmin/pull/8180) and the engine namespace is now isolated.

## Localization Updates

Please [review the en.yml locale](https://github.com/activeadmin/activeadmin/blob/master/config/locales/en.yml) for the latest translations.

**Removed keys:** `dashboard_welcome`, `dropdown_actions`, `main_content`, `unsupported_browser`.

**New keys:** `toggle_dark_mode`, `toggle_main_navigation_menu`, `toggle_section`, `toggle_user_menu`.

**`active_admin.pagination` rewritten:**

```diff
- one: "Displaying <b>1</b> %{model}"
+ one: "Showing <b>1</b> of <b>1</b>"
- one_page: "Displaying <b>all %{n}</b> %{model}"
+ one_page: "Showing <b>all %{n}</b>"
- multiple: "Displaying %{model} <b>%{from}&nbsp;-&nbsp;%{to}</b> of <b>%{total}</b> in total"
+ multiple: "Showing <b>%{from}-%{to}</b> of <b>%{total}</b>"
- multiple_without_total: "Displaying %{model} <b>%{from}&nbsp;-&nbsp;%{to}</b>"
+ multiple_without_total: "Showing <b>%{from}-%{to}</b>"
- per_page: "Per page: "
+ per_page: "Per page "
+ previous: "Previous"
+ next: "Next"
```

**`active_admin.search_status` rewritten:**

```diff
- headline: "Search status:"
- current_scope: "Scope:"
- current_filters: "Current filters:"
+ title: "Active Search"
+ title_with_scope: "Active Search for %{name}"
- no_current_filters: "None"
+ no_current_filters: "No filters applied"
```

**Other locale changes:**

- `status_tag.unset` changed from `"No"` to `"Unknown"`.
- `comments.title_content` now has an `"All "` prefix.
- `comments.delete_confirmation` fixed to use singular form.
- `batch_actions.succesfully_destroyed` renamed to fix a typo:

  ```diff
  - succesfully_destroyed:
  + successfully_destroyed:
  ```

- Login/sign-in terms standardized to `"Sign in"`, `"Sign out"`, and `"Sign up"` throughout.
