## Master (unreleased) - [compare](https://github.com/gregbell/active_admin/compare/v0.6.0...master)

### Features

* OmniAuth provider links now automatically appear on the login page [#2088][] by [@henrrrik][]
* Menu items can now properly overflow [#2046][] by [@maax][]; later updated in [#2125][] by [@ball-hayden][]

### Bug Fixes

* Fixes problem where extra `/` route was being generated [#2062][] by [@jbhannah][]
* `IndexAsBlog` now renders title/body procs in the view context [#2087][] by [@macfanatic][]
* Fixes `route_instance_path` for `belongs_to` resources [#2099][] by [@pcreux][]
* Fixes breadcrumb links for `belongs_to` resources [#2090][] by [@Daxter][]
* Forces a `I18n.reload!` to ensure translations are loaded in production [#2072][] [@ericpromislow][]

### Enhancements

* Adds option to "undecorate" resource when building forms [#2085][] by [@amiel][]
* Adds [better_errors](https://github.com/charliesome/better_errors) gem for a better AA development experience [#2095][] by [@Daxter][]
* Scopes now support blocks for the `:default` option [#2084][] by [@macfanatic][]
* `:if` and `:unless` options added to `scope_to` [#2089][] by [@macfanatic][]
* German (Switzerland), English (UK) locales added [#1916][] by [@psy-q][]
* Renames Comment to AdminComment [#2060][] by [@jbhannah][]; later replaced by [#2113][]
* Improves Comments UI and adds config settings [#2113][] by [@Daxter][]
```ruby
    config.show_comments_in_menu      = false          # Defaults to true
    config.comments_registration_name = 'AdminComment' # Defaults to 'Comment'
```

* `has_many` forms
  * Adds 'has_many_delete' CSS class to `li` elements [#2054][] by [@shekibobo][]
  * Adds `:heading` option to customize the heading displayed [#2068][] by [@coreyward][]
  * Adds `:allow_destroy` option to add in a checkbox to the form to delete records [#2071][] by [@shekibobo][]

### Cleanup

* Cucumber step definitions refactor [#2015][] by [@Daxter][]
* Misc cleanup in [#2075][] and [#2107][] by [@Daxter][]
* Removes messy spacing from `AdminUser` generator file [#2058][] by [@lupinglade][]
* Fixes documentation formatting [#2083][] by [@amiel][]

## 0.6.0 - [compare](https://github.com/gregbell/active_admin/compare/v0.5.1...v0.6.0)

### Bug Fixes

* Fix conflict with Redcloth [#1805][] by [@adrienkohlbecker][]
* Add missing batch actions translations. [#1788][] by [@EtienneDepaulis][]
* JS fix for batch actions checkbox toggling [#1947][] by [@ai][]
* Fixed routing bug for root namespace [#2043][] by [@Daxter][] and [@gregbell][]

### Enhancements

* Rubinis compatability change over block variables [#1871][] by [@dbussin][]
* Compatability with Draper 1.0 release [#1896][] by [@hakanensari][]
* Fixed references to "dashboards.rb" in locales, since file doesn't exist [#1873][] by [@ryansch][]
* Removing deprecated bourbon box-shadow mixin [#1913][] by [@stereoscott][]
* More Japanese localizations [#1929][] by [@johnnyshields][]
* Devise lockable module now supported by default [#1933][] by [@Bishop][]
* Index table now uses a unique DOM id (`#index_table_posts` instead of `#posts`) [#1966][] by [@TiagoCardoso1983][]
* Coffeescript 1.5 compatability as constructors no longer return a value [#1940][] by [@ronen][]
* Allow options to be passed to the Abre element for rows in `attributes_table` [#1439][] by [@Daxter][]
* Gender neutral Spanish translations [#1973][] by [@laffinkippah][]
* Adds the ability to use `starts_with` and `ends_with` in string filters [#1962][] by [@rmw][]
* Adds support for translating resources when registered with `:as` [#2044][] by [@Daxter][]
* Scopes are no longer hidden when empty filter results [#1804][] by [@Daxter][]
* Dynamic scope names with procs [#2018][] by [@Daxter][]
* Filters now support the `:if` optional argument [#1801][] by [@Daxter][]
* Member & collection actions support multiple HTTP methods for the same action [#2000][] by [@rdsoze][]

### Features

* Authorization DSL including a default CanCan adapter [#1817][] by [@pcreux][] and [@gregbell][]
* New "actions" DSL for customizing actions on index listing [#1834][] by [@ejholmes][]
* Index title can now be set via a proc [#1861][] by [@jamesalmond][]
* Can now disable `download_links` per resource, index collection or globally throughout AA [#1908][] by [@TBAA][]
* Filters: add ability to search for blank/null fields with boolean search [#1893][] by [@whatcould][]
* New `navigation_menu` DSL for menu system [#1967][] by [@macfanatic][] and [@gregbell][]
* Support segmented control switch between different index styles [#1745][] by [@joshuacollins85][]

### Other

* Updated documentation for formtastic deprecated f.buttons [#1867][] by [@ericcumbee][]
* Copyright updated for 2013 [#1937][] by [@snapapps][]

### Contributors

327 Commits by 42 authors

*  Adrien Kohlbecker
*  Alexandr Prudnikov
*  Andrew Pietsch
*  Andrey A.I. Sitnik
*  Andrey Rozhkovsky
*  Anthony Zacharakis
*  Bartlomiej Niemtur
*  David DIDIER
*  David Reese
*  Daxter
*  Dirkjan Bussink
*  Dominik Masur
*  Eric Cumbee
*  Eric J. Holmes
*  Etienne Depaulis
*  Gosha Arinich
*  Greg Bell
*  Ian Carroll
*  James Almond
*  Johnny Shields
*  Joshua Collins
*  Kieran Klaassen
*  Luís Ramalho
*  Matt Brewer
*  Nathaniel Bibler
*  Olek Janiszewski
*  Philippe Creux
*  Raison Dsouza
*  Rebecca Miller-Webster
*  Roman Sklenar
*  Roman Sklenář
*  Ryan Schlesinger
*  Scott Meves
*  Sean Ian Linsley
*  Sergey Pchelincev
*  Simon Menke
*  Tiago Cardoso
*  Travis Pew
*  WU Jun
*  laffinkippah
*  ronen barzel
*  тιηуηυмвєяѕ

## 0.5.1 - [compare](https://github.com/gregbell/active_admin/compare/v0.5.0...v0.5.1)

### Enhancements

* Developer can pass options for CSV generation. [#1626][] by [@rheaton][]
```ruby
    ActiveAdmin.register Post do
      csv options: {force_quotes: true} do
        column :title
      end
    end
```

* Breadcrumb links can be customized by [@simonoff][]
```ruby
    ActiveAdmin.register Post do
      breadcrumb do
        [
          link_to("My account", account_path(current_user))
        ]
      end
    end
```

* Support proc for parent options on menus [#1664][] by [@shell][]
```ruby
    ActiveAdmin.register Post do
      menu parent: proc { I18n.t("admin") }
    end
```

* Support automatic use of Decorators. [#1117][] by [@amiel][] and [#1647][] by [@dapi][]
```ruby
    ActiveAdmin.register Post do
      decorate_with PostDecorator
    end
```

* Allow blacklisting of filters with 'remove_filter' [#1609][] by [@tracedwax][]
```ruby
    ActiveAdmin.register Post do
      remove_filter :author
    end
```

* ActiveAdmin i18n translations can be overwritten in your rails
application locales. [#1775][] by [@caifara][]
* Add "Powered by" to translations. [#1783][] by [@sunny][]
* Forms accept two level deeps has_many. [#1699][] by [@kerberoS][] and tests in [#1782][] by [@ptn][]
* Extract download_format_links into helper [#1752][] by [@randym][]
* Add support for semantic errors [#905][] by [@robdiciuccio][]
* Add support for boolean inputs [#1668][] by [@orendon][]
* Support subURI on logout [#1681][] by [@yawn][]

### Bug fix
* Apply before_filter to BaseController [#1683][] by [@yorch][]
* ... and much more.

### Contributions

156 commits (49 Pull Requests) by 51 contributors.

## 0.5.0 - [compare](https://github.com/gregbell/active_admin/compare/v0.4.4...v0.5.0)

### Enhancements

* Created new view components (Footer, TitleBar, Header, UtilityNav) to more
  easily customize the views in Active Admin and per namespace. ([@gregbell][])
* All CSS is now encapsulated under the `body.active_admin` class. This may
  change the precedence of styles that you created to override or use in
  other areas of your application.
* Dashboards are now implemented as pages. For more details of how to configure
  a page, checkout http://activeadmin.info/docs/9-custom-pages.html
* Root route can be set to any controller#action using `#root_to`.
* Batch Actions allows you to select entries on index page and perform
  an action against them.
* CSV separators are configurable.
* Lot of bug fixes.

### Deprecations

* Removed all references to ActiveAdmin::Renderer. If you were using these
  please update code to use an Arbre component. Removed
  `ActiveAdmin:Views::HeaderRender` and replaced with
  `ActiveAdmin::Views::Header` component.
* ActiveAdmin::Menu and ActiveAdmin::MenuItem API has changed. If you were
  creating custom menu items, the builder syntax has changed to. Menu#add now
  accepts a MenuItem, instead of building the menu item for you.
* `ActiveAdmin::Dashboards.build` is deprecated in favour of generating a page
  and using the new `config.root_to` option.
* Arbre is now a gem on its own.

### Contributions

561 commits (142 Pull Requests) by 88 contributors.

## 0.4.4 - [compare](https://github.com/gregbell/active_admin/compare/v0.4.3...v0.4.4)

### Dependencies

* Use `formtastic` ~> 2.1.1 until AA 0.5.0 is released
* Use `inherited_resources` >= 1.3.1 (ensure flash messages work)

## 0.4.3 - [compare](https://github.com/gregbell/active_admin/compare/v0.4.2...v0.4.3)

### Bug Fixes

* [#1063][]: Fix comment issues when using postgres ([@jancel][])

## 0.4.2 - [compare](https://github.com/gregbell/active_admin/compare/v0.4.1...v0.4.2)

### Enhancements

* [#822][]: Automatically include js and css to precompile list ([@jschwindt][])
* [#1033][]: Site title accepts a proc that is rendered in the context
         of the view ([@pcreux][])
* [#70][]: Form blocks are now rendered within the context of the view ([@gregbell][])
* [#70][]: Filter's collections are now eval'd in the context of the view ([@gregbell][])
* [#1032][]: The html body now includes a class for the namespace name ([@mattvague][])
* [#1013][]: Hide the count from one specific scope using `:show_count => false`
         ([@latortuga][])
* [#1023][]: Add localization support for comments ([@MoritzMoritz][])

### Bug Fixes

* [#34][]: Comments now work with models using string ids ([@jancel][])
* [#1041][]: When `table_for` collection is empty it no longer outputs
         a blank array in Ruby 1.9 ([@jancel][], [#1016][])
* [#983][]: Fixed compatibility with pry-rails ([@pcreux][])
* [#409][]: Install generator handles custom class names for user ([@gregbell][])

### Contributors

42 Commits by 10 authors

* Allen Huang
* Daniel Lepage
* Thibaut Barrère
* Drew Ulmer
* Juan Schwindt
* Moritz Behr
* Jeff Ancel
* Matt Vague
* Greg Bell
* Philippe Creux


## 0.4.1 - [compare](https://github.com/gregbell/active_admin/compare/v0.4.0...v0.4.1)

### Enhancements

* [#865][]: Pages support the `#page_action` to add custom controller actions
        to a page ([@BoboFraggins][])
* Columns component now supports column spans, max and min widths ([@gregbell][])
* [#497][]: Custom pagination settings per resource ([@pcreux][])
* [#993][]: Login form now focuses on email ([@mattvague][])
* [#865][]: Add `:if` support to sidebar sections ([@BoboFraggins][])
* [#865][]: Added `:scope_count => false` to the index to hide scope counts
        in generated scopes ([@BoboFraggins][])

### Bug Fixes

* [#101][]: Global nav now works with RackBaseURI ([@gregbell][])
* [#960][]: Global nav works when scoped in rails routes ([@gregbell][])
* [#994][]: Fix index page check collection.limit(1).exists? causes exception when
        ordering by virtual colum ([@latortuga][], [@gregbell][])
* [#971][]: Fix SQL when sorting tables with a column named "group" ([@ggilder][])

### Dependencies

* [#978][]: Support for Inherited Resources 1.3.0 ([@fabiormoura][])

### Contributors

75 Commits by 12 authors

* Bruno Bonamin
* David Radcliffe
* Dinesh Majrekar
* Erik Michaels-Ober
* Fábio Maia
* Gabriel Gilder
* Greg Bell
* Kyle Macey
* Matt Vague
* Oldani Pablo
* Peter Fry
* Philippe Creux
* Søren Houen


## 0.4.0 - [compare](https://github.com/gregbell/active_admin/compare/v0.3.4...v0.4.0)

### Upgrade Notes

If you're running on Rails 3.0.x, make sure to run `rails generate active_admin:assets`
since we've changed both the CSS and JS files.

### Deprecations

* In the initializer `config.allow_comments_in = []` is now
  `config.allow_comments = true`. Use the new namespace specific configurations
  to allow or disallow configuration within a specific namespace.
* Removed `Object#to_html` in favour of `to_s`. Any Arbre components
  implementing a `to_html` method need to be updated to use `to_s` instead.

### New Features

* Namespace specific configurations in the initializer ([@gregbell][])
* [#624][]: Set an image as the site title using `config.site_title_image` in the
  Active Admin initializer. ([@mattvague][])
* [#758][]: Create a standalone page in Active Admin using
  `ActiveAdmin.register_page` ([@pcreux][])
* [#723][]: Register stylesheets with a media type ([@macfanatic][])

### Enhancements

* [#428][]: Paginated Collection now supports `:param_name` and `:download_links`.
  These two additions allow you to use the `paginated_collection` component multiple
  times on show screens. ([@samvincent][])
* [#527][]: Refactored all form helpers to use Formtastic 2([@ebeigarts][])
* [#551][]: Dashboards can now be conditionally displayed using `:if` ([@samvincent][])
* [#555][]: scopes now accept `:if`. They only get displayed if the proc returns true ([@macfanatic][])
* [#601][]: Breadcrumbs are internationalized ([@vairix-ssierra][])
* [#605][]: Validations on ActiveAdmin::Comment should work with
  `accepts_nested_attributes_for` ([@DMajrekar ][])
* [#623][]: Index table can sort on any table using `:sort => 'table.column'` ([@ZequeZ][])
* [#638][]: Add `:label` option to `status_tag` component ([@fbuenemann][])
* [#644][]: Added proper I18n support to pagination ([@fbuenemann][])
* [#689][]: Scopes preserve title when provided as a string ([@macfanatic][])
* [#711][]: Styles update. Now sexier and more refined design. Redesigned Scopes. Split
  css into smaller files. ([@mattvague][])
* [#741][]: Default media type of css is now "all" instead of "screen" ([@sftsang][])
* [#751][]: Pagination numbers work with a custom `[@per_page][]` ([@DMajrekar][])
* `default_actions` in an index table only display implemented actions ([@watson][])

### Bug Fixes

* [#590][]: Comments now work in the default namespace ([@jbarket][])
* [#780][]: Fix stack level too deep exception when logout path is setup to use
  `:logout_path` named route. ([@george][])
* [#637][]: Fix scope all I18n ([@fbuenemann][])
* [#496][]: Remove global `Object#to_html` [@ebeigarts][]
* [#470][], [#154][]: Arbre properly supports blocks that return Numeric values
  ([@bobbytables][], [@utkarshkukreti][], [@gregbell][])
* [#897][]: Fix count display for collections with GROUP BY [@comboy][]

### Dependencies

* [#468][]: Removed vendored jQuery. Now depends on the jquery-rails gem. If you're
  running Rails 3.0.x (no asset pipeline), make sure to run
  `rails generate active_admin:assets` to generate the correct files. ([@gregbell][])
* [#527][]: Active Admin now requires Formtastic 2.0 or greater ([@ebeigarts][])
* [#711][]: Active admin now depends on Bourbon > 1.0.0. If you're using Rails
  3.0.x, make sure to run `rails generate active_admin:assets` to ensure you
  have the correct css files ([@mattvague][])
* [#869][]: Upgraded Kaminari to >= 0.13.0 and added support for
  `Kaminari.config.page_method_name`. Active Admin should now be happy if
  `will_paginate` is installed with it. ([@j][]-manu)
* [#931][]: Support for Rails 3.2 added ([@mperham][])

### Contributors

274 commits by 42 authors

 * Greg Bell
 * Philippe Creux
 * Matt Vague
 * Felix Bünemann
 * Matthew Brewer
 * Edgars Beigarts
 * Mike Perham
 * Sam Vincent
 * Kieran Klaassen
 * Jonathan Barket
 * Ankur Sethi
 * Dinesh Majrekar
 * comboy
 * Juan E. Pemberthy
 * Leandro Moreira
 * Manu
 * Marc Riera
 * Radan Skorić
 * Rhys Powell
 * Sebastian Sierra
 * Sherman Tsang
 * Szymon Przybył
 * Thomas Watson Steen
 * Tim Habermaas
 * Yara Mayer
 * Zequez
 * asancio
 * emmek
 * Alexey Noskov
 * igmizo
 * Alli
 * Bendik Lynghaug
 * Douwe Homans
 * Eric Koslow
 * Eunsub Kim
 * Garami Gábor
 * George Anderson
 * Henrik Hodne
 * Ivan Storck
 * Jeff Dickey
 * John Ferlito
 * Josef Šimánek


## 0.3.4 - [compare](https://github.com/gregbell/active_admin/compare/v0.3.3...v0.3.4)

2 commits by 2 authors

### Bug Fixes

* Fix reloading issues across operating systems.
* Fix issue where SASS was recompiling on every request. This can seriously
  decrease the load time of applications when running in development mode.
  Thanks [@dhiemstra][] for tracking this one down!

### Contributors

* Danny Hiemstra
* Greg Bell

## 0.3.3 - [compare](https://github.com/gregbell/active_admin/compare/v0.3.2...v0.3.3)

1 commit by 1 author

### Enhancements

* Only reload Active Admin when files in the load paths have changed. This is a
  major speed increase in development mode. Also helps with memory consumption
  because we aren't reloading Active admin all the time.

### Contributors

* Greg Bell

## 0.3.2 - [compare](https://github.com/gregbell/active_admin/compare/v0.3.1...v0.3.2)

45 commits by 15 contributors

### Enhancements

* Site title can now be a link. Use config.site_title_link in
  config/initializers/active_admin.rb
* i18n support for Japanese
* i18n support for Bulgarian
* i18n support for Swedish

### Bug Fixes

* DeviseGenerator respects singular table names
* Active Admin no longer assumes sass-rails is installed
* Arbre::Context passes methods to the underlying html which fixes
  issues on different types of servers (and on Heroku)
* [#45][]: Fix for multibyte characters ([@tricknotes][])
* [#505][]: Fix titlebar height when no breadcrumb ([@mattvague][])
* Fixed vertical align in dashboard
* Fixed i18n path's for multi-word model names

### Dependencies

* Formtastic 2.0.0 breaks Active Admin. Locking to < 2.0.0

### Contributors

* Amiel Martin
* Christian Hjalmarsson
* Edgars Beigarts
* Greg Bell
* Jan Dupal
* Joe Van
* Mark Roghelia
* Mathieu Martin
* Matt Vague
* Philippe Creux
* Ryunosuke SATO
* Sam Vincent
* Trace Wax
* Tsvetan Roustchev
* l4u

## 0.3.1 - [compare](https://github.com/gregbell/active_admin/compare/v0.3.0...v0.3.1)

* Only support InheritedResources up to 1.2.2

## 0.3.0 - [compare](https://github.com/gregbell/active_admin/compare/v0.2.2...v0.3.0)

326 commits by 35 contributors

### New Features

* I18n! Now supported in 10 languages!
* Customizeable CSV ([@pcreux][], [@gregbell][])
* Menus now support `if` and `priority` (Moritz Lawitschka)
* Rails 3.1 support
* Asset pipeline support ([@gregbell][])
* `skip_before_filter` now supported in DSL ([@shayfrendt][])
* Added a blank slate design ([@mattvague][])
* Collection and Member actions use the Active Admin layout ([@gregbell][])

### Enhancements

* Better I18n config file loading ([@fabiokr][])
* `TableFor` now supports I18n headers ([@fabiokr][])
* `AttributesTable` now supports I18n attributes ([@fabiokr][])
* Member actions all use CSS class `member_link` ([@doug316][])
* Made `status_tag` an Arbre component ([@pcreux][])
* CSV downloads have sexy names such as "articles-2011-06-21.csv" ([@pcreux][])
* Created `ActiveAdmin::Setting` to easily create settings ([@gregbell][])
* New datepicker styles ([@mattvague][])
* Set `[@page_title][]` in member action to render a custom title ([@gregbell][])
* [#248][]: Settable logout link options in initializer ([@gregbell][])
* Added a DependencyChecker that warns if dependencies aren't met ([@pcreux][])

### Bug Fixes

* [#52][]: Fix update action with STI models ([@gregbell][])
* [#122][]: Fix sortable columns on nested resources ([@knoopx][])
* Fix so that Dashboard Sections can appear in root namespace ([@knoopx][])
* [#131][]: Fixed `status_tag` with nil content ([@pcreux][])
* [#110][]: Fixed dropdown menu floats in Firefox ([@mattvague][])
* Use quoted table names ([@krug][])
* Fixed CSS float of `.paginated_collection_contents` bug in Firefox ([@mattvague][])
* Removed unwanted gradient in IE in attribute table headers ([@emzeq][])
* [#222][]: Added `Arbre::Context#length` for Rack servers ([@gregbell][])
* [#255][]: Fixed problem with dropdown menus in IE8 and IE9 ([@mattvague][])
* [#235][]: Default sort order should use primary_key ([@gregbell][])
* [#197][]: Fixed issues with #form params disappearing ([@rolfb][])
* [#186][]: Fixes for when `default_namespace = false` ([@gregbell][])
* [#135][]: Comments on STI classes redirect correctly ([@gregbell][])
* [#77][]: Fixed performance issue where ActiveRecord::Base.all was being called ([@pcreux][])
* [#332][]: Fixed Devise redirection when in false namespace ([@gregbell][])
* [#171][]: Fixed issue where class names would clash with HTML object names ([@gregbell][])
* [#381][]: Fixed issues with Devise < 1.2 ([@pcreux][])
* [#369][]: Added support for pluralized model names such as News ([@gregbell][])
* [#42][]: Default forms work with polymorphic associations ([@mattvague][])

### Dependencies

* Switched from will_paginate to  Kaminari for pagination ([@mwindwer][])
* Removed dependency on InheritedViews ([@gregbell][])
* Removed Jeweler. Using Bundler and a gemspec ([@gregbell][])

### Contributors

* Armand du Plessis
* Aurelio Agundez
* Bruno Bonamin
* Chris Ostrowski
* Corey Woodcox
* DeLynn Berry
* Doug Puchalski
* Fabio Kreusch
* Greg Bell
* Ismael G Marin C
* Jackson Pires
* Jesper Hvirring Henriksen
* Josef Šimánek
* Jørgen Orehøj Erichsen
* Liborio Cannici
* Matt Vague
* Matthew Windwer
* Moritz Lawitschka
* Nathan Le Ray
* Nicolas Mosconi
* Philippe Creux
* Rolf Bjaanes
* Ryan D Johnson
* Ryan Krug
* Shay Frendt
* Steve Klabnik
* Tiago Rafael Godinho
* Toby Hede
* Vijay Dev
* Víctor Martínez
* doabit
* hoverlover
* nhurst
* whatthewhat
* Łukasz Anwajler


## 0.2.2 (2011-05-26) - [compare](https://github.com/gregbell/active_admin/compare/v0.2.1...v0.2.2)

68 Commits by 13 Contributors

### Features & Enhancements

* Arbre includes self closing tags ([#100][])
* Controller class & action added to body as CSS classes ([#99][])
* HAML is not required by default ([#92][])
* Devise login now respects Devise.authentication_keys ([#69][])
* Active Admin no longer uses <tt>ActiveRecord::Base#search</tt> ([#28][])
* Resource's can now override the label in the menu ([#48][])
* Subdirectories are now loaded in the Active Admin load path

### Bug Fixes

* Sort order now includes table name ([#38][])
* Fixed table_for 'odd', 'even' row classes ([#96][])
* Fixed Devise installation if AdminUser already exists ([#95][])
* Fixed issues when ActiveAdmin.default_namespaces is false ([#32][])
* Added styles for missing HTML 5 inputs ([#31][])
* Fixed issue if adding empty Active Admin Comment ([#21][])
* Fixed layout issues in FF 4 ([#22][])
* Use Sass::Plugin.options[:css_location] instead of Rails.root ([#55][])

### Test Suite

* Update RSpec to latest & fix specs (Thanks Ben Marini & Jeremt Ruppel!) ([#100][])
* Added tests for STI models ([#52][])

### Contributors

* Ben Marini
* Bookis Smuin
* Caley Woods
* Doug Puchalski
* Federico Romero
* Greg Bell
* Ian MacLeod
* Jeremy Ruppel
* Jordan Sitkin
* Juha Suuraho
* Mathieu Martin
* Paul Annesley
* Philippe Creux

## 0.2.1 (2011-05-12) - [compare](https://github.com/gregbell/active_admin/compare/v0.2.0...v0.2.1)

### Bug Fixes
* Fixed issue with dashboard rendering a sidebar

## 0.2.0 (2011-05-12) - [compare](https://github.com/gregbell/active_admin/compare/v0.1.1...v0.2.0)

0.2.0 is essentially an entire re-write of Active Admin. Here are some
of the highlights. 250 commits. Enough said.

### Features & Enhancements

* Full visual redesign
* Integrated Devise for authentication
* Brand new view and component layer called Arbre (Project coming soon)
* Added ActiveAdmin::Comments

### Bug Fixes

* Too many to list! Been in production for close to a year

## 0.1.1 (2010-09-15) - [compare](https://github.com/gregbell/active_admin/compare/v0.1.0...v0.1.1)

### Bug Fixes

* Fixed issues running on Ruby 1.9.2

## 0.1.0

* Initial release

<!--- The following link definition list is generated by PimpMyChangelog --->
[#21]: https://github.com/gregbell/active_admin/issues/21
[#22]: https://github.com/gregbell/active_admin/issues/22
[#28]: https://github.com/gregbell/active_admin/issues/28
[#31]: https://github.com/gregbell/active_admin/issues/31
[#32]: https://github.com/gregbell/active_admin/issues/32
[#34]: https://github.com/gregbell/active_admin/issues/34
[#38]: https://github.com/gregbell/active_admin/issues/38
[#42]: https://github.com/gregbell/active_admin/issues/42
[#45]: https://github.com/gregbell/active_admin/issues/45
[#48]: https://github.com/gregbell/active_admin/issues/48
[#52]: https://github.com/gregbell/active_admin/issues/52
[#55]: https://github.com/gregbell/active_admin/issues/55
[#69]: https://github.com/gregbell/active_admin/issues/69
[#70]: https://github.com/gregbell/active_admin/issues/70
[#77]: https://github.com/gregbell/active_admin/issues/77
[#92]: https://github.com/gregbell/active_admin/issues/92
[#95]: https://github.com/gregbell/active_admin/issues/95
[#96]: https://github.com/gregbell/active_admin/issues/96
[#99]: https://github.com/gregbell/active_admin/issues/99
[#100]: https://github.com/gregbell/active_admin/issues/100
[#101]: https://github.com/gregbell/active_admin/issues/101
[#110]: https://github.com/gregbell/active_admin/issues/110
[#122]: https://github.com/gregbell/active_admin/issues/122
[#131]: https://github.com/gregbell/active_admin/issues/131
[#135]: https://github.com/gregbell/active_admin/issues/135
[#154]: https://github.com/gregbell/active_admin/issues/154
[#171]: https://github.com/gregbell/active_admin/issues/171
[#186]: https://github.com/gregbell/active_admin/issues/186
[#197]: https://github.com/gregbell/active_admin/issues/197
[#222]: https://github.com/gregbell/active_admin/issues/222
[#235]: https://github.com/gregbell/active_admin/issues/235
[#248]: https://github.com/gregbell/active_admin/issues/248
[#255]: https://github.com/gregbell/active_admin/issues/255
[#332]: https://github.com/gregbell/active_admin/issues/332
[#369]: https://github.com/gregbell/active_admin/issues/369
[#381]: https://github.com/gregbell/active_admin/issues/381
[#409]: https://github.com/gregbell/active_admin/issues/409
[#428]: https://github.com/gregbell/active_admin/issues/428
[#468]: https://github.com/gregbell/active_admin/issues/468
[#470]: https://github.com/gregbell/active_admin/issues/470
[#496]: https://github.com/gregbell/active_admin/issues/496
[#497]: https://github.com/gregbell/active_admin/issues/497
[#505]: https://github.com/gregbell/active_admin/issues/505
[#527]: https://github.com/gregbell/active_admin/issues/527
[#551]: https://github.com/gregbell/active_admin/issues/551
[#555]: https://github.com/gregbell/active_admin/issues/555
[#590]: https://github.com/gregbell/active_admin/issues/590
[#601]: https://github.com/gregbell/active_admin/issues/601
[#605]: https://github.com/gregbell/active_admin/issues/605
[#623]: https://github.com/gregbell/active_admin/issues/623
[#624]: https://github.com/gregbell/active_admin/issues/624
[#637]: https://github.com/gregbell/active_admin/issues/637
[#638]: https://github.com/gregbell/active_admin/issues/638
[#644]: https://github.com/gregbell/active_admin/issues/644
[#689]: https://github.com/gregbell/active_admin/issues/689
[#711]: https://github.com/gregbell/active_admin/issues/711
[#723]: https://github.com/gregbell/active_admin/issues/723
[#741]: https://github.com/gregbell/active_admin/issues/741
[#751]: https://github.com/gregbell/active_admin/issues/751
[#758]: https://github.com/gregbell/active_admin/issues/758
[#780]: https://github.com/gregbell/active_admin/issues/780
[#822]: https://github.com/gregbell/active_admin/issues/822
[#865]: https://github.com/gregbell/active_admin/issues/865
[#869]: https://github.com/gregbell/active_admin/issues/869
[#897]: https://github.com/gregbell/active_admin/issues/897
[#905]: https://github.com/gregbell/active_admin/issues/905
[#931]: https://github.com/gregbell/active_admin/issues/931
[#960]: https://github.com/gregbell/active_admin/issues/960
[#971]: https://github.com/gregbell/active_admin/issues/971
[#978]: https://github.com/gregbell/active_admin/issues/978
[#983]: https://github.com/gregbell/active_admin/issues/983
[#993]: https://github.com/gregbell/active_admin/issues/993
[#994]: https://github.com/gregbell/active_admin/issues/994
[#1013]: https://github.com/gregbell/active_admin/issues/1013
[#1016]: https://github.com/gregbell/active_admin/issues/1016
[#1023]: https://github.com/gregbell/active_admin/issues/1023
[#1032]: https://github.com/gregbell/active_admin/issues/1032
[#1033]: https://github.com/gregbell/active_admin/issues/1033
[#1041]: https://github.com/gregbell/active_admin/issues/1041
[#1063]: https://github.com/gregbell/active_admin/issues/1063
[#1117]: https://github.com/gregbell/active_admin/issues/1117
[#1439]: https://github.com/gregbell/active_admin/issues/1439
[#1609]: https://github.com/gregbell/active_admin/issues/1609
[#1626]: https://github.com/gregbell/active_admin/issues/1626
[#1647]: https://github.com/gregbell/active_admin/issues/1647
[#1664]: https://github.com/gregbell/active_admin/issues/1664
[#1668]: https://github.com/gregbell/active_admin/issues/1668
[#1681]: https://github.com/gregbell/active_admin/issues/1681
[#1683]: https://github.com/gregbell/active_admin/issues/1683
[#1699]: https://github.com/gregbell/active_admin/issues/1699
[#1745]: https://github.com/gregbell/active_admin/issues/1745
[#1752]: https://github.com/gregbell/active_admin/issues/1752
[#1775]: https://github.com/gregbell/active_admin/issues/1775
[#1782]: https://github.com/gregbell/active_admin/issues/1782
[#1783]: https://github.com/gregbell/active_admin/issues/1783
[#1788]: https://github.com/gregbell/active_admin/issues/1788
[#1801]: https://github.com/gregbell/active_admin/issues/1801
[#1804]: https://github.com/gregbell/active_admin/issues/1804
[#1805]: https://github.com/gregbell/active_admin/issues/1805
[#1817]: https://github.com/gregbell/active_admin/issues/1817
[#1834]: https://github.com/gregbell/active_admin/issues/1834
[#1861]: https://github.com/gregbell/active_admin/issues/1861
[#1867]: https://github.com/gregbell/active_admin/issues/1867
[#1871]: https://github.com/gregbell/active_admin/issues/1871
[#1873]: https://github.com/gregbell/active_admin/issues/1873
[#1893]: https://github.com/gregbell/active_admin/issues/1893
[#1896]: https://github.com/gregbell/active_admin/issues/1896
[#1908]: https://github.com/gregbell/active_admin/issues/1908
[#1913]: https://github.com/gregbell/active_admin/issues/1913
[#1929]: https://github.com/gregbell/active_admin/issues/1929
[#1933]: https://github.com/gregbell/active_admin/issues/1933
[#1937]: https://github.com/gregbell/active_admin/issues/1937
[#1940]: https://github.com/gregbell/active_admin/issues/1940
[#1947]: https://github.com/gregbell/active_admin/issues/1947
[#1960]: https://github.com/gregbell/active_admin/issues/1960
[#1961]: https://github.com/gregbell/active_admin/issues/1961
[#1962]: https://github.com/gregbell/active_admin/issues/1962
[#1966]: https://github.com/gregbell/active_admin/issues/1966
[#1967]: https://github.com/gregbell/active_admin/issues/1967
[#1973]: https://github.com/gregbell/active_admin/issues/1973
[#2000]: https://github.com/gregbell/active_admin/issues/2000
[#2018]: https://github.com/gregbell/active_admin/issues/2018
[#2043]: https://github.com/gregbell/active_admin/issues/2043
[#2044]: https://github.com/gregbell/active_admin/issues/2044
[@Bishop]: https://github.com/Bishop
[@BoboFraggins]: https://github.com/BoboFraggins
[@DMajrekar]: https://github.com/DMajrekar
[@Daxter]: https://github.com/Daxter
[@EtienneDepaulis]: https://github.com/EtienneDepaulis
[@MoritzMoritz]: https://github.com/MoritzMoritz
[@TBAA]: https://github.com/TBAA
[@TiagoCardoso1983]: https://github.com/TiagoCardoso1983
[@ZequeZ]: https://github.com/ZequeZ
[@adrienkohlbecker]: https://github.com/adrienkohlbecker
[@ai]: https://github.com/ai
[@amiel]: https://github.com/amiel
[@bobbytables]: https://github.com/bobbytables
[@caifara]: https://github.com/caifara
[@comboy]: https://github.com/comboy
[@dapi]: https://github.com/dapi
[@dbussin]: https://github.com/dbussin
[@dhiemstra]: https://github.com/dhiemstra
[@doug316]: https://github.com/doug316
[@ebeigarts]: https://github.com/ebeigarts
[@ejholmes]: https://github.com/ejholmes
[@emzeq]: https://github.com/emzeq
[@ericcumbee]: https://github.com/ericcumbee
[@fabiokr]: https://github.com/fabiokr
[@fabiormoura]: https://github.com/fabiormoura
[@fbuenemann]: https://github.com/fbuenemann
[@george]: https://github.com/george
[@ggilder]: https://github.com/ggilder
[@gregbell]: https://github.com/gregbell
[@hakanensari]: https://github.com/hakanensari
[@j]: https://github.com/j
[@jamesalmond]: https://github.com/jamesalmond
[@jancel]: https://github.com/jancel
[@jbarket]: https://github.com/jbarket
[@johnnyshields]: https://github.com/johnnyshields
[@joshuacollins85]: https://github.com/joshuacollins85
[@jschwindt]: https://github.com/jschwindt
[@kerberoS]: https://github.com/kerberoS
[@knoopx]: https://github.com/knoopx
[@krug]: https://github.com/krug
[@laffinkippah]: https://github.com/laffinkippah
[@latortuga]: https://github.com/latortuga
[@macfanatic]: https://github.com/macfanatic
[@mattvague]: https://github.com/mattvague
[@mperham]: https://github.com/mperham
[@mwindwer]: https://github.com/mwindwer
[@orendon]: https://github.com/orendon
[@page_title]: https://github.com/page_title
[@pcreux]: https://github.com/pcreux
[@per_page]: https://github.com/per_page
[@ptn]: https://github.com/ptn
[@randym]: https://github.com/randym
[@rdsoze]: https://github.com/rdsoze
[@rheaton]: https://github.com/rheaton
[@rmw]: https://github.com/rmw
[@robdiciuccio]: https://github.com/robdiciuccio
[@rolfb]: https://github.com/rolfb
[@ronen]: https://github.com/ronen
[@ryansch]: https://github.com/ryansch
[@samvincent]: https://github.com/samvincent
[@sftsang]: https://github.com/sftsang
[@shayfrendt]: https://github.com/shayfrendt
[@shell]: https://github.com/shell
[@simonoff]: https://github.com/simonoff
[@snapapps]: https://github.com/snapapps
[@stereoscott]: https://github.com/stereoscott
[@sunny]: https://github.com/sunny
[@tracedwax]: https://github.com/tracedwax
[@tricknotes]: https://github.com/tricknotes
[@utkarshkukreti]: https://github.com/utkarshkukreti
[@vairix]: https://github.com/vairix
[@vairix-ssierra]: https://github.com/vairix-ssierra
[@watson]: https://github.com/watson
[@whatcould]: https://github.com/whatcould
[@yawn]: https://github.com/yawn
[@yorch]: https://github.com/yorch
