# Changelog

## Master (unreleased)

### Bug Fixes

* Fixed [#4173][] by including the default Kaminari templates [#5069][] by [@javierjulio][]
* Fixed [#5043][]. Do not crash in sidebar rendering when a default scope is not
  specified. [#5044] by [@Fivell][].
* Fixed [#3894][]. Make tab's component work with non-ascii titles. [#5046] by
  [@Fivell][].

### Removals

* Ruby 2.1 support has been dropped [#5002][] by [@deivid-rodriguez][]
* Replaced `sass-rails` with `sass` dependency [#5037][] by [@javierjulio][]

### Deprecations

* Deprecated `config.register_stylesheet` and `config.register_javascript`. Import
  your CSS and JS files in `active_admin.scss` or `active_admin.js`. [#5060][] by [@javierjulio][]
* Deprecated `type` param from `status_tag` and related CSS classes [#4989][] by [@javierjulio][]
  * The method signature has changed from:

    ```ruby
    status_tag(status, :ok, class: 'completed', label: 'on')
    ```

    to:

    ```ruby
    status_tag(status, class: 'completed ok', label: 'on')
    ```

  * The following CSS classes have been deprecated and will be removed in the future:

    ```css
    .status_tag {
      &.ok, &.published, &.complete, &.completed, &.green { background: #8daa92; }
      &.warn, &.warning, &.orange { background: #e29b20; }
      &.error, &.errored, &.red { background: #d45f53; }
    }
    ```

### Enhancements

#### Minor

* Support proc as an input_html option value when declaring filters [#5029][] by [@Fivell][]
* Base localization support, better associations handling for active filters sidebar [#4951][] by [@Fivell][]
* Allow AA scopes to return paginated collections [#4996][] by [@Fivell][]
* Added `scopes_show_count` configuration to  setup show_count attribute for scopes globally [#4950][] by [@Fivell][]
* Allow custom panel title given with `attributes_table` [#4940][] by [@ajw725][]
* Allow passing a class to `action_item` block [#4997][] by [@Fivell][]

## 1.0.0 [☰](https://github.com/activeadmin/activeadmin/compare/v0.6.3...master)

### Breaking Changes

* Rename `allow_comments` to `comments` for more consistent naming [#3695][] by [@pranas][]
* JavaScript `window.AA` has been removed, use `window.ActiveAdmin` [#3606][] by [@timoschilling][]
* `f.form_buffers` has been removed [#3486][] by [@varyonic][]
* Iconic has been removed [#3553][] by [@timoschilling][]
* `config.show_comments_in_menu` has been removed, see `config.comments_menu` [#4187][] by [@drn][]
* Rails 3.2 & Ruby 1.9.3 support has been dropped [#4848][] [@deivid-rodriguez][]
* Ruby 2.0.0 support has been dropped [#4851][] [@deivid-rodriguez][]
* Rails 4.0 & 4.1 support has been dropped [#4855][] [@deivid-rodriguez][]

### Enhancements

#### Major

* Migration from Metasearch to Ransack [#1979][] by [@seanlinsley][]
* Rails 4 support [#2326][] by many people :heart:
* Rails 4.2 support [#3731][] by [@gonzedge][] and [@timoschilling][]
* Rails 5 support [#4254][] by [@seanlinsley][]
* Rails 5.1 support [#4882][] by [@varyonic][]

#### Minor

* "Create another" checkbox for the new resource page. [#4477][] by [@bolshakov][]
* Page supports belongs_to [#4759][] by [@Fivell][] and [@zorab47][]
* Support for custom sorting strategies [#4768][] by [@Fivell][]
* Stream CSV downloads as they're generated [#3038][] by [@craigmcnamara][]
  * Disable streaming in development for easier debugging [#3535][] by [@seanlinsley][]
* Improved code reloading [#3783][] by [@chancancode][]
* Do not auto link to inaccessible actions [#3686][] by [@pranas][]
* Allow to enable comments on per-resource basis [#3695][] by [@pranas][]
* Unify DSL for index `actions` and `actions dropdown: true` [#3463][] by [@timoschilling][]
* Add DSL method `includes` for `ActiveRecord::Relation#includes` [#3464][] by [@timoschilling][]
* BOM (byte order mark) configurable for CSV download [#3519][] by [@timoschilling][]
* Column block on table index is now sortable by default [#3075][] by [@dmitry][]
* Allow Arbre to be used inside ActiveAdmin forms [#3486][] by [@varyonic][]
* Make AA ORM-agnostic [#2545][] by [@johnnyshields][]
* Add multi-record support to `attributes_table_for` [#2544][] by [@zorab47][]
* Table CSS classes are now prefixed to prevent clashes [#2532][] by [@TimPetricola][]
* Allow Inherited Resources shorthand for redirection [#2001][] by [@seanlinsley][]

```ruby
    controller do
      # Redirects to index page instead of rendering updated resource
      def update
        update!{ collection_path }
      end
    end
```

* Accept block for download links [#2040][] by [@potatosalad][]

```ruby
index download_links: ->{ can?(:view_all_download_links) || [:pdf] }
```

* Comments menu can be customized via configuration passed to `config.comments_menu` [#4187][] by [@drn][]
* Added `config.route_options` to namespace to customize routes [#4467][] by [@stereoscott[]]

### Security Fixes

* Prevents access to formats that the user not permitted to see [#4867][] by [@Fivell][] and [@timoschilling][]
* Prevents potential DOS attack via Ruby symbols [#1926][] by [@seanlinsley][]
  * [this isn't an issue for those using Ruby >= 2.2](http://rubykaigi.org/2014/presentation/S-NarihiroNakamura)

### Bug Fixes

* Fixes filters for `has_many :through` relationships [#2541][] by [@shekibobo][]
* "New" action item now only shows up on the index page bf659bc by [@seanlinsley][]
* Fixes comment creation bug with aliased resources 9a082486 by [@seanlinsley][]
* Fixes the deletion of `:if` and `:unless` from filters [#2523][] by [@PChambino][]

### Deprecations

* `ActiveAdmin::Event` (`ActiveAdmin::EventDispatcher`) [#3435][] by [@timoschilling][]
  `ActiveAdmin::Event` will be removed in a future version, ActiveAdmin switched
  to use `ActiveSupport::Notifications`.
  NOTE: The blog parameters has changed:

```ruby
ActiveSupport::Notifications.subscribe ActiveAdmin::Application::BeforeLoadEvent do |event, *args|
  # some code
end

ActiveSupport::Notifications.publish ActiveAdmin::Application::BeforeLoadEvent, "some data"
```

## Previous Changes

Please check [0-6-stable](https://github.com/activeadmin/activeadmin/blob/0-6-stable/CHANGELOG.md) for previous changes.

[#1926]: https://github.com/activeadmin/activeadmin/issues/1926
[#1979]: https://github.com/activeadmin/activeadmin/issues/1979
[#2001]: https://github.com/activeadmin/activeadmin/issues/2001
[#2040]: https://github.com/activeadmin/activeadmin/issues/2040
[#2326]: https://github.com/activeadmin/activeadmin/issues/2326
[#2523]: https://github.com/activeadmin/activeadmin/issues/2523
[#2532]: https://github.com/activeadmin/activeadmin/issues/2532
[#2541]: https://github.com/activeadmin/activeadmin/issues/2541
[#2544]: https://github.com/activeadmin/activeadmin/issues/2544
[#2545]: https://github.com/activeadmin/activeadmin/issues/2545
[#3038]: https://github.com/activeadmin/activeadmin/issues/3038
[#3075]: https://github.com/activeadmin/activeadmin/issues/3075
[#3463]: https://github.com/activeadmin/activeadmin/issues/3463
[#3464]: https://github.com/activeadmin/activeadmin/issues/3464
[#3486]: https://github.com/activeadmin/activeadmin/issues/3486
[#3519]: https://github.com/activeadmin/activeadmin/issues/3519
[#3535]: https://github.com/activeadmin/activeadmin/issues/3535
[#3553]: https://github.com/activeadmin/activeadmin/issues/3553
[#3606]: https://github.com/activeadmin/activeadmin/issues/3606
[#3686]: https://github.com/activeadmin/activeadmin/issues/3686
[#3695]: https://github.com/activeadmin/activeadmin/issues/3695
[#3731]: https://github.com/activeadmin/activeadmin/issues/3731
[#3783]: https://github.com/activeadmin/activeadmin/issues/3783
[#3894]: https://github.com/activeadmin/activeadmin/issues/3894
[#4187]: https://github.com/activeadmin/activeadmin/issues/4187
[#4173]: https://github.com/activeadmin/activeadmin/issues/4173
[#4254]: https://github.com/activeadmin/activeadmin/issues/4254
[#5043]: https://github.com/activeadmin/activeadmin/issues/5043

[#4477]: https://github.com/activeadmin/activeadmin/pull/4477
[#4759]: https://github.com/activeadmin/activeadmin/pull/4759
[#4768]: https://github.com/activeadmin/activeadmin/pull/4768
[#4848]: https://github.com/activeadmin/activeadmin/pull/4848
[#4851]: https://github.com/activeadmin/activeadmin/pull/4851
[#4867]: https://github.com/activeadmin/activeadmin/pull/4867
[#4882]: https://github.com/activeadmin/activeadmin/pull/4882
[#4940]: https://github.com/activeadmin/activeadmin/pull/4940
[#4950]: https://github.com/activeadmin/activeadmin/pull/4950
[#4951]: https://github.com/activeadmin/activeadmin/pull/4951
[#4989]: https://github.com/activeadmin/activeadmin/pull/4989
[#4996]: https://github.com/activeadmin/activeadmin/pull/4996
[#4997]: https://github.com/activeadmin/activeadmin/pull/4997
[#5029]: https://github.com/activeadmin/activeadmin/pull/5029
[#5002]: https://github.com/activeadmin/activeadmin/pull/5002
[#5037]: https://github.com/activeadmin/activeadmin/pull/5037
[#5044]: https://github.com/activeadmin/activeadmin/pull/5044
[#5046]: https://github.com/activeadmin/activeadmin/pull/5046
[#5060]: https://github.com/activeadmin/activeadmin/pull/5060
[#5069]: https://github.com/activeadmin/activeadmin/pull/5069

[@ajw725]: https://github.com/ajw725
[@bolshakov]: https://github.com/bolshakov
[@chancancode]: https://github.com/chancancode
[@craigmcnamara]: https://github.com/craigmcnamara
[@deivid-rodriguez]: https://github.com/deivid-rodriguez
[@dmitry]: https://github.com/dmitry
[@drn]: https://github.com/drn
[@Fivell]: https://github.com/Fivell
[@gonzedge]: https://github.com/gonzedge
[@javierjulio]: https://github.com/javierjulio
[@johnnyshields]: https://github.com/johnnyshields
[@PChambino]: https://github.com/PChambino
[@potatosalad]: https://github.com/potatosalad
[@pranas]: https://github.com/pranas
[@seanlinsley]: https://github.com/seanlinsley
[@shekibobo]: https://github.com/shekibobo
[@timoschilling]: https://github.com/timoschilling
[@TimPetricola]: https://github.com/TimPetricola
[@varyonic]: https://github.com/varyonic
[@zorab47]: https://github.com/zorab47
