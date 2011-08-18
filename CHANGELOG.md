## Master

### New Features

* Customizeable CSV (@pcreux, @gregbell)
* Menus now support `if` and `priority` (Moritz Lawitschka)
* Rails 3.1 support
* Asset pipeline support (@gregbell)
* `skip_before_filter` now supported in DSL (@shayfrendt)
* Added a blank slate design (@mattvague)
* Collection and Member actions use the Active Admin layout (@gregbell)

### Enhancements

* Better I18n config file loading (@fabiokr)
* `TableFor` now supports I18n headers (@fabiokr)
* `AttributesTable` now supports I18n attributes (@fabiokr)
* Member actions all use CSS class `member_link` (@doug316)
* Made `status_tag` an Arbre component (@pcreux)
* CSV downloads have sexy names such as "articles-2011-06-21.csv" (@pcreux)
* Created `ActiveAdmin::Setting` to easily create settings (@gregbell)
* New datepicker styles (@mattvague)

### Bug Fixes

* #52: Fix update action with STI models (@gregbell)
* #122: Fix sortable columns on nested resources (@knoopx)
* Fix so that Dashboard Sections can appear in root namespace (@knoopx)
* #131: Fixed `status_tag` with nil content (@pcreux)
* #110: Fixed dropdown menu floats in Firefox (@mattvague)
* Use quoted table names (@krug)
* Fixed CSS float of `.paginated_collection_contents` bug in Firefox (@mattvague)
* Removed unwanted gradient in IE in attribute table headers (@emzeq)
* #222: Added `Arbre::Context#length` for Rack servers (@gregbell)

### Dependencies

* Switched from will_paginate to  Kaminari for pagination (@mwindwer)
* Removed dependency on InheritedViews (@gregbell)
* Removed Jeweler. Using Bundler and a gemspec (@gregbell)

### Test Suite

* Removed reloading. Cukes went from 6min to 48s (@gregbell)
* Upgraded to latest cucumber (@gregbell)


## 0.2.2 (2011-05-26)

68 Commits by 13 Contributors

### Features & Enhancements

* Arbre includes self closing tags (#100)
* Controller class & action added to body as CSS classes (#99)
* HAML is not required by default (#92)
* Devise login now respects Devise.authentication_keys (#69)
* Active Admin no longer uses <tt>ActiveRecord::Base#search</tt> (#28)
* Resource's can now override the label in the menu (#48)
* Subdirectories are now loaded in the Active Admin load path

### Bug Fixes

* Sort order now includes table name (#38)
* Fixed table_for 'odd', 'even' row classes (#96)
* Fixed Devise installation if AdminUser already exists (#95)
* Fixed issues when ActiveAdmin.default_namespaces is false (#32)
* Added styles for missing HTML 5 inputs (#31)
* Fixed issue if adding empty Active Admin Comment (#21)
* Fixed layout issues in FF 4 (#22)
* Use Sass::Plugin.options[:css_location] instead of Rails.root (#55)

### Test Suite

* Update RSpec to latest & fix specs (Thanks Ben Marini & Jeremt Ruppel!) (#100)
* Added tests for STI models (#52)

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
