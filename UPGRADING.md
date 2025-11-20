# Upgrading Guide

## From v3 to v4 (beta)

ActiveAdmin v4 uses Tailwind CSS v4. It has **mobile web, dark mode and RTL support** with a default theme that can be customized through partials and CSS. This release assumes `cssbundling-rails` and `importmap-rails` is installed and configured in the host app. Partials can be modified to include a different asset library, e.g. shakapacker.
**IMPORTANT**: there is **no sortable functionality for has-many forms** in this release so if needed, **do not upgrade**. We are [open to community proposals](https://github.com/activeadmin/activeadmin/discussions/new?category=ideas). The add/remove functionality for has-many forms remains supported.

These instructions assume the `cssbundling-rails` and `importmap-rails` gems are already installed and you have run their install commands in your app. If you haven't done so, please do before continuing.

Update your `Gemfile` with `gem "activeadmin", "4.0.0.beta19"` and then run `gem install activeadmin --pre`.

Now, run `rails generate active_admin:assets` to replace the old assets with the new files.

Then add the npm package and update the `build:css` script.

```
yarn add @activeadmin/activeadmin@4.0.0-beta19
npm pkg set scripts.build:css="npx @tailwindcss/cli -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify"
```

If you are already using Tailwind in your app, then update the `build:css` script to chain the above command to your existing one, e.g. `"npx @tailwindcss/cli ... && npx @tailwindcss/cli ..."`, so both stylesheets are generated.

Many configs have been removed (meta tags, asset registration, utility nav, etc.) that can now be modified more naturally through partials.

Open the `config/initializers/active_admin.rb` file and remove these deleted configs.

```
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

Now, run `rails g active_admin:views` which will copy the partials to your app so you can customize if needed.

Note that the templates can and will change across releases. There are additional partials that can be copied but they are considered private so you do so at your own risk. You will have to keep those up to date per release.

**IMPORTANT**: if your project has copied any ActiveAdmin, Devise, or Kaminari templates from earlier releases, those templates must be updated from this release to avoid potential errors. Path helpers in Devise templates may require using the `main_app` proxy. The Kaminari templates have moved to `app/views/active_admin/kaminari`.

With the setup complete, please review the Breaking Changes section and resolve any that may or may not impact your integration.

### Upgrading from earlier 4.x beta to 4.0.0.beta19

When upgrading from any earlier 4.0.0 beta release, please apply the changes outlined below.

There were important template changes in 4.0.0.beta16. See [PR #8727](https://github.com/activeadmin/activeadmin/pull/8727) for details.
- The `_site_header.html.erb` partial has changed its main container class from `sticky` to `fixed`.
- The main layout for `active_admin.html.erb` now includes the `pt-16` utility class.

Starting with 4.0.0.beta19, we've migrated to Tailwind CSS v4 which requires several updates.

Update your `active_admin.css` file:

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

You may see the following warning when upgrading:

```
[MODULE_TYPELESS_PACKAGE_JSON] Warning: Module type of tailwind-active_admin.config.js is not specified and it doesn't parse as CommonJS.
Reparsing as ES module because module syntax was detected. This incurs a performance overhead.
To eliminate this warning, add "type": "module" to ./package.json.
```

The Tailwind config file now uses ES module syntax. To fix it, either:
- Rename `tailwind-active_admin.config.js` to `tailwind-active_admin.config.mjs`; or
- Add `"type": "module"` to your `package.json` (your application may already be compatible with ESM).

### Breaking Changes
- jQuery and jQuery UI have been removed.
- The `columns` component has been removed. Use `div`'s with Tailwind classes for modern, responsive layout.

  <details>
  <summary>Columns Component Migration Alternative</summary>

  If you did not specify any parameters for `column` and if all you need is equal width columns, then this single component will restore that functionality for any number of columns.

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

- The `tabs` component has been removed. Use a CSS based or third party alternative.
- Replace `default_main_content` with `render "show_default"`.

  <details>
  <summary>Show Default Alternative</summary>

  If block form `default_main_content do ... end` was used or looking for a partial file
  alternative, then replace with existing, public methods.

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

- Replace `as: :datepicker` with Formtastic's `as: :date_picker` for native HTML date input.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- In a sidebar section, replace `attributes_table` with `attributes_table_for(resource)`.
- The `IndexAsBlog`, `IndexAsBlock` and `IndexAsGrid` components have been removed. Please create your own custom index-as components which remain supported.
- Batch Actions Form DSL has been replaced with Rails partial support so you can supply your own custom form and modal.

  <details>
  <summary>Batch Action Partial Example</summary>

  Assuming a Post resource (in the default namespace) with a `mark_published` batch action, we set the partial name and a set of HTML data attributes to trigger a modal using Flowbite which is included by default.

  Note that you can use any modal JS library you want as long as it can be triggered to open using data attributes. Flowbite usage is not a requirement.

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

  In the `app/views/admin/posts` directory, create a `_mark_published_batch_action.html.erb` partial file which will be rendered and included automatically in the posts index admin page.

  Now add the modal HTML where the `id` attribute must match the data attributes supplied in the `batch_action` example. The form must have an empty `data-batch-action-form` attribute.

  ```
  <div id="mark-published-modal" class="hidden fixed top-0 ..." aria-hidden="true" ...>
    <!-- ... other modal content --->
    <%= form_tag false, "data-batch-action-form": "" do %>
      <!-- Declare your form inputs. You can use a different form builder too. -->
    <% end %>
  </div>
  ```

  The `data-batch-action-form` attribute is a hook for a delegated JS event so when you submit the form, it will post and run your batch action block with the supplied form data, functioning as it did before.
  </details>

- Deeply nested submenus has been reverted. Only one level nested menu, e.g. `menu parent: "Administrative"`, is supported.
- Removed `Panel#header_action` method.
- Removed `index_column` method from index table.

  <details>
  <summary>Implementation Example</summary>

  You can re-implement this column with the following:

  ```ruby
  column "Number", sortable: false do |item|
    @collection.offset_value + @collection.index(item) + 1
  end
  ```
  </details>
- Using `row 'name'` in an `attributes_table` block, now prints the header text as is. For a localized lookup of the header with titlized fallback, use `row :name` instead. This matches the `column 'name'` behavior of index tables (`TableFor`).

#### Resource named methods

With the extraction to partials, resource named methods, e.g. `post` or `posts`, used in blocks for `action_item` and `sidebar` will raise an error. You must use the `resource` or `collection` public helper method instead. For example:

```ruby
action_item :view, if: ->{ post.published? } do link_to(resource) end
sidebar :author, if: ->{ post.published? }
# The above must now change to the following:
action_item :view, if: ->{ resource.published? } do link_to(resource) end
sidebar :author, if: ->{ resource.published? }
```

Note that `@post` can also be used here but make sure to call `authorize!` on it if using the authorization feature. The `post` usage would continue to work for `sidebar :name do ... end` content blocks because they can include Arbre but we advise using `resource` or `collection` instead where possible. This may impact other DSL's.

### Visual Related Changes
- The `sidebar do ... end` contents and the show resource `attributes_table`, are no longer wrapped in a panel so they can be customized.
- Links in custom `action_item`'s have no default styles. Apply your own or use the library's default `action-item-button` class.
- The index table `actions dropdown: true` option will be ignored, reverting to original output.
- An `Arbre::Component` will no longer add a CSS class using the component class name by default.
- Typographic elements (other than links in main content) [are not styled by default](https://tailwindcss.com/docs/preflight). Use the `@tailwindcss/typography` plugin or apply your own CSS alternative.

### Enhancements
- Dark mode support.
- Mobile web support. For responsive `table_for`'s, wrap them in a div with overflow for horizontal scrolling.
- Customizable admin theme, including main menu and user menu, all through partials.
- RTL support improved. Now using CSS Logical Properties.
- Kaminari templates now consolidated into a single set you can customize.
- Datepicker's now use the native HTML date input. Apply a custom datepicker of your choosing.
- Batch Actions Form DSL has been replaced with partials and form builder for more customization. Please refer to earlier example.
- The `status_tag` component now uses unique labels for `false` and `nil` values.
- Several components: `table_for`, `status_tag`, etc. now use data attributes instead of classes for metadata: status, sort direction, column, etc.
- Arbre builder methods have been reduced to the minimum so you can use elements or DSLs without clashing e.g. `header`, `footer`, `columns`, etc.
- The [app-helpers-not-reloading bug has been fixed](https://github.com/activeadmin/activeadmin/pull/8180) and the engine namespace is now isolated.

### Localization Updates

This release includes several locale changes. Please [review the en.yml locale](https://github.com/activeadmin/activeadmin/blob/master/config/locales/en.yml) for the latest translations.

- Removed keys: `dashboard_welcome`, `dropdown_actions`, `main_content` and `unsupported_browser`.
- New keys: `toggle_dark_mode`, `toggle_main_navigation_menu`, `toggle_section`, and `toggle_user_menu` have been added.
- The `active_admin.pagination` keys have been rewritten to be less verbose and include new entries: next and previous.

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

- The `search_status` key contents has multiple, breaking changes:

  ```diff
  - headline: "Search status:"
  - current_scope: "Scope:"
  - current_filters: "Current filters:"
  + title: "Active Search"
  + title_with_scope: "Active Search for %{name}"
  - no_current_filters: "None"
  + no_current_filters: "No filters applied"
  ```

- The value for the `status_tag.unset` key has changed from "No" to "Unknown".
- The `comments.title_content` text has been updated with an "All " prefix.
- The `comments.delete_confirmation` text has been fixed to use singular form.
- The `batch_actions.succesfully_destroyed` key has been renamed to fix a typo.

  ```diff
  - succesfully_destroyed:
  + successfully_destroyed:
  ```
- Inconsistent use of login/sign-in related terms so text now uses "Sign in", Sign out", and "Sign up" throughout.
