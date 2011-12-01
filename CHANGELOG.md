## Master

### Upgrade Notes

If you're running on Rails 3.0.x, make sure to run `rails generate active_admin:assets` 
since we've changed both the CSS and JS files.

### Deprecations

* In the initializer `config.allow_comments_in = []` is now
  `config.allow_comments = true`. Use the new namespace specific configurations
  to allow or disallow configuration within a specific namespace.

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

### Dependencies

* [#468][]: Removed vendored jQuery. Now depends on the jquery-rails gem. If you're 
  running Rails 3.0.x (no asset pipeline), make sure to run 
  `rails generate active_admin:assets` to generate the correct files. ([@gregbell][])
* [#527][]: Active Admin now requires Formtastic 2.0 or greater ([@ebeigarts][])
* [#711][]: Active admin now depends on Bourbon > 1.0.0. If you're using Rails
  3.0.x, make sure to run `rails generate active_admin:assets` to ensure you
  have the correct css files ([@mattvague][])

### Contributors

202 commits by 31 authors

* Bendik Lynghaug
* Dinesh Majrekar
* Douwe Homans
* Edgars Beigarts
* Eunsub Kim
* Felix Bünemann
* George Anderson
* Greg Bell
* Henrik Hodne
* Ivan Storck
* Jeff Dickey
* John Ferlito
* Jonathan Barket
* Josef Šimánek
* Juan E.
* Kieran Klaassen
* Marc Riera
* Matt Vague
* Matthew Brewer
* Philippe Creux
* Radan Skorić
* Rhys Powell
* Sam Vincent
* Sebastian Sierra
* Sherman Tsang
* Szymon Przybył
* Thomas Watson
* Yara Mayer
* Zequez 
* emmek 

## 0.3.4

2 commits by 2 authors

### Bug Fixes

* Fix reloading issues across operating systems.
* Fix issue where SASS was recompiling on every request. This can seriously
  decrease the load time of applications when running in development mode.
  Thanks [@dhiemstra][] for tracking this one down!

### Contributors

* Danny Hiemstra
* Greg Bell

## 0.3.3

1 commit by 1 author

### Enhancements

* Only reload Active Admin when files in the load paths have changed. This is a
  major speed increase in development mode. Also helps with memory consumption
  because we aren't reloading Active admin all the time.

### Contributors

* Greg Bell

## 0.3.2

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

## 0.3.1

* Only support InheritedResources up to 1.2.2

## 0.3.0

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


## 0.2.2 (2011-05-26)

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

## 0.2.1 (2011-05-12)

### Bug Fixes
* Fixed issue with dashboard rendering a sidebar

## 0.2.0 (2011-05-12)

0.2.0 is essentially an entire re-write of Active Admin. Here are some
of the highlights. 250 commits. Enough said.

### Features & Enhancements

* Full visual redesign
* Integrated Devise for authentication
* Brand new view and component layer called Arbre (Project coming soon)
* Added ActiveAdmin::Comments

### Bug Fixes

* Too many to list! Been in production for close to a year

## 0.1.1 (2010-09-15)

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
[#38]: https://github.com/gregbell/active_admin/issues/38
[#42]: https://github.com/gregbell/active_admin/issues/42
[#45]: https://github.com/gregbell/active_admin/issues/45
[#48]: https://github.com/gregbell/active_admin/issues/48
[#52]: https://github.com/gregbell/active_admin/issues/52
[#55]: https://github.com/gregbell/active_admin/issues/55
[#69]: https://github.com/gregbell/active_admin/issues/69
[#77]: https://github.com/gregbell/active_admin/issues/77
[#92]: https://github.com/gregbell/active_admin/issues/92
[#95]: https://github.com/gregbell/active_admin/issues/95
[#96]: https://github.com/gregbell/active_admin/issues/96
[#99]: https://github.com/gregbell/active_admin/issues/99
[#100]: https://github.com/gregbell/active_admin/issues/100
[#110]: https://github.com/gregbell/active_admin/issues/110
[#122]: https://github.com/gregbell/active_admin/issues/122
[#131]: https://github.com/gregbell/active_admin/issues/131
[#135]: https://github.com/gregbell/active_admin/issues/135
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
[#428]: https://github.com/gregbell/active_admin/issues/428
[#468]: https://github.com/gregbell/active_admin/issues/468
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
[#741]: https://github.com/gregbell/active_admin/issues/741
[#751]: https://github.com/gregbell/active_admin/issues/751
[#758]: https://github.com/gregbell/active_admin/issues/758
[#780]: https://github.com/gregbell/active_admin/issues/780
[@DMajrekar]: https://github.com/DMajrekar
[@ZequeZ]: https://github.com/ZequeZ
[@dhiemstra]: https://github.com/dhiemstra
[@doug316]: https://github.com/doug316
[@ebeigarts]: https://github.com/ebeigarts
[@emzeq]: https://github.com/emzeq
[@fabiokr]: https://github.com/fabiokr
[@fbuenemann]: https://github.com/fbuenemann
[@george]: https://github.com/george
[@gregbell]: https://github.com/gregbell
[@jbarket]: https://github.com/jbarket
[@knoopx]: https://github.com/knoopx
[@krug]: https://github.com/krug
[@macfanatic]: https://github.com/macfanatic
[@mattvague]: https://github.com/mattvague
[@mwindwer]: https://github.com/mwindwer
[@page_title]: https://github.com/page_title
[@pcreux]: https://github.com/pcreux
[@per_page]: https://github.com/per_page
[@rolfb]: https://github.com/rolfb
[@samvincent]: https://github.com/samvincent
[@sftsang]: https://github.com/sftsang
[@shayfrendt]: https://github.com/shayfrendt
[@tricknotes]: https://github.com/tricknotes
[@vairix]: https://github.com/vairix-ssierra
[@watson]: https://github.com/watson
