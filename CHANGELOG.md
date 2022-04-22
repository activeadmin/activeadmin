# Changelog

## Unreleased

## 2.12.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.11.2..v2.12.0)

### Enhancements

* Add Ransack 3 compatibility. [#7453] by [@tagliala]

### Bug Fixes

* Fix pundit namespace detection. [#7144] by [@vlad-psh]

### Documentation

* Don't mention webpacker as the default asset generator in Rails. [#7377] by [@jaynetics]

### Performance

* Avoid duplicate work when downloading CSV. [#7336] by [@deivid-rodriguez]

## 2.11.2 [☰](https://github.com/activeadmin/activeadmin/compare/v2.11.1..v2.11.2)

### Bug Fixes

* Fix disappearing BOM option for `CSVBuilder`. [#7170] by [@Karoid]

## 2.11.1 [☰](https://github.com/activeadmin/activeadmin/compare/v2.11.0..v2.11.1)

### Enhancements

* Add turbolinks support to has many js. [#7384] by [@amiel]

### Documentation

* Remove `insert_tag` from Form-Partial docs. [#7394] by [@TonyArra]

## 2.11.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.10.1..v2.11.0)

### Enhancements

* Add Rails 7 Support. [#7235] by [@tagliala]

### Bug Fixes

* Fix form SCSS variables no longer being defined in the outermost scope, so no longer being accessible. [#7341] by [@gigorok]

## 2.10.1 [☰](https://github.com/activeadmin/activeadmin/compare/v2.10.0..v2.10.1)

### Enhancements

* Apply `box-sizing: border-box` globally. [#7349] by [@deivid-rodriguez]
* Vendor normalize 8.0.1. [#7350] by [@deivid-rodriguez]
* Remove deprecation warning using controller filters inside initializer. [#7340] by [@mgrunberg]

### Bug Fixes

* Fix frozen string error when downloading CSV and streaming disabled. [#7332] by [@deivid-rodriguez]

## 2.10.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.9.0..v2.10.0)

### Enhancements

* Load favicon from Webpacker assets when use_webpacker is set to true. [#6954] by [@Fs00]
* Don't apply sorting to collection until after scoping. [#7205] by [@agrobbin]
* Resolve dart sass deprecation warning for division. [#7095] by [@tordans]
* Use `instrument` from the Notifications API instead of low level `publish`. [#7262] by [@sprql]
* Avoid mutating string literals. [#6936] by [@tomgilligan]
* Include print styles in main stylesheet. [#6922] by [@deivid-rodriguez]
* Use `POST` for OmniAuth links. [#6916] by [@deivid-rodriguez]
* Scope new record instantiation by authorization scope. [#6884] by [@ngouy]
* Make `permit_params` and `belongs_to` order independent. [#6906] by [@deivid-rodriguez]
* Use collection length instead of running COUNTs for limited collections. [#5660] by [@MmKolodziej]

### Bug Fixes

* Show ransackable_scopes filters in search results. [#7127] by [@vlad-psh]

### Translation Improvements

* Fix Dutch translation for password reset button. [#7181] by [@mvz]
* Add few key to RO pagination.entry. [#6915] by [@lubosch]
* Change misleading Korean translation. [#6873] by [@1000ship]

### Documentation

* Replace deprecated update_attributes! with update!. [#6959] by [@sergey-alekseev]
* Clarify docs on user setup. [#6872] by [@javawizard]

### Dependency Changes

* Drop rails 5.2 support. [#7293] by [@deivid-rodriguez]
* Drop support for Ruby 2.5. [#7236] by [@alejandroperea]

## 2.9.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.8.1..v2.9.0)

### Enhancements

* Support for Rails 6.1. [#6548] by [@deivid-rodriguez]
* Add ability to override "Remove" button text on has_many forms. [#6523] by [@littleforest]
* Drop git in gemspec. [#6462] by [@utkarsh2102]

### Bug Fixes

* Pick up upstream fixes in devise templates. [#6536] by [@munen]

### Documentation

* Fix `has_many` syntax in forms documentation. [#6583] by [@krzcho]
* Add example of using `default_main_content` in show pages. [#6487] by [@sjieg]

### Dependency Changes

* Remove sassc and sprockets runtime dependencies. [#6584] by [@deivid-rodriguez]

## 2.8.1 [☰](https://github.com/activeadmin/activeadmin/compare/v2.8.0..v2.8.1)

### Bug Fixes

* Fix `permitted_param` generation for `belongs_to` when `:param` is used. [#6460] by [@deivid-rodriguez]
* Fix streaming CSV export. [#6451] by [@deivid-rodriguez]
* Fix input string filter no rendering dropdown input when its column name ends with a ransack predicate. [#6422] by [@Fivell]

## 2.8.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.7.0..v2.8.0)

### Enhancements

* Allow using PORO decorators. [#6249] by [@brunvez]
* Make sure `ActiveAdmin.routes` provides routes in a consistent order. [#6124] by [@jiikko]
* Use proper closing tags for HTML in ModalDialog component. [#6221] by [@javierjulio]

### Bug Fixes

* Fix comment layout so regardless of size, each is aligned and spaced evenly. [#6393] by [@Ivanov-Anton]

### Translation Improvements

* Fix several Arabic translations. [#6368] by [@mshalaby]
* Add missing `scope/all` italian translation. [#6341] by [@fuzziness]
* Improve Japanese translation. [#6315] by [@rn0rno]
* Fix es and es-MX sign_in and sign_up translation. [#6210] by [@roramirez]

### Documentation

* Fix filter_columns_for_large_association and filter_method_for_large_association examples. [#6232] by [@ndbroadbent]

### Dependency Changes

* Allow formtastic 4. [#6318] by [@deivid-rodriguez]
* Drop Ruby 2.4 support. [#6198] by [@deivid-rodriguez]

## 2.7.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.6.1..v2.7.0)

### Enhancements

* Extend menu to allow for nested submenus. [#5994] by [@taralbass]
* Add Webpacker compatibility with opt-in config switch and installation generator. [#5855] by [@sgara]

### Bug Fixes

* Fix scopes renderer when resource has only optional scopes and their conditions are false. [#6149] by [@Looooong]
* Fix some missing wrapper markup in "logged out" layout. [#6086] by [@irmela]
* Fix some typos in Vietnamese translation. [#6099] by [@giapnhdev]

## 2.6.1 [☰](https://github.com/activeadmin/activeadmin/compare/v2.6.0..v2.6.1)

### Bug Fixes

* Fix some ruby 2.7 warnings about keyword args. [#6000] by [@vcsjones]
* Missing `create_another` translation in Vietnamese. [#6002] by [@imcvampire]
* Using "destroy" for user facing message is too robotic, prefer "delete". [#6047] by [@vfonic]
* Typo in confirmation message for comment deletion. [#6047] by [@vfonic]

## 2.6.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.5.0..v2.6.0)

### Enhancements

* Display multiple flash messages in separate elements. [#5929] by [@mirelon]
* Make delete confirmation messages in French & Spanish gender-neutral. [#5946] by [@cprodhomme]

### Bug Fixes

* Export ModalDialog component to re-enable client side usage. [#5956] by [@sgara]
* Use default ActionView options instead of default Formtastic options for DateRangeInput [#5957] by [@mirelon]
* Fix i18n key in docs example to translate scopes. [#5943] by [@adler99]

## 2.5.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.4.0..v2.5.0)

### Enhancements

* Azerbaijani translation. [#5078] by [@orkhan]

### Bug Fixes

* Convert namespace to sym to prevent duplicate namespaces such as :foo and 'foo'. [#5931] by [@westonganger]
* Use filter label when condition has a predicate. [#5886] by [@ko-lem]
* Fix error when routing with array containing symbol. [#5870] by [@jwesorick]
* Fix error when there is a model named `Tag` and `meta_tags` have been configured. [#5895] by [@micred], [@FabioRos] and [@deivid-rodriguez]
* Allow specifying custom `input_html` for `DateRangeInput`. [#5867] by [@mirelon]
* Adjust `#main_content` right margin to take into account possible custom values of `$sidebar-width` and `$section-padding`. [#5887] by [@guigs]
* Improved polymorphic routes generation to avoid problems when multiple `belongs_to` are defined. [#5938] by [@leio10]

### Dependency Changes

* Support for Rails 5.0 and Rails 5.1 has been dropped. [#5877] by [@deivid-rodriguez]

## 2.4.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.3.1..v2.4.0)

### Enhancements

* Make optimization to not use expensive COUNT queries also work for decorated actions. [#5811] by [@irmela]
* Render a text filter instead of a select for large associations (opt-in). [#5548] by [@DanielHeath]
* Improve German translations. [#5874] by [@juril33t]

## 2.3.1 [☰](https://github.com/activeadmin/activeadmin/compare/v2.3.0..v2.3.1)

### Bug Fixes

* Revert ransack version pinning because 2.3 has an outstanding bug that affects quite a lot of users. See [this ransack issue](https://github.com/activerecord-hackery/ransack/issues/1039) for more information. [#5854] by [@deivid-rodriguez]

## 2.3.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.2.0..v2.3.0)

### Enhancements

* Bump minimum ransack requirement to make sure everyone gets a version that works ok with all supported versions of Rails. [#5831] by [@deivid-rodriguez]

### Bug Fixes

* Fix CSVBuilder not respecting `ActiveAdmin.application.csv_options = { humanize_name: false }` setting. [#5800] by [@HappyKadaver]
* Fix crash when displaying current filters after filtering by a nested resource. [#5816] by [@deivid-rodriguez]
* Fix pagination when `pagination_total` is false to not show a "Last" link, since it's incorrect because we don't have the total pages information. [#5822] by [@deivid-rodriguez]
* Fix optional nested resources causing incorrect routes to be generated, when renamed resources (through `:as` option) are involved. [#5826] by [@ndbroadbent], [@Kris-LIBIS] and [@deivid-rodriguez]
* Fix double modal issue in applications using turbolinks 5. [#5842] by [@sgara]

## 2.2.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.1.0..v2.2.0)

### Enhancements

* The `status_tag` component now supports different labels for `false` and `nil` boolean cases through the locale. Both default to display "No" for backwards compatibility. [#5794] by [@javierjulio]
* Add Macedonian locale. [#5710] by [@violeta-p]

### Bug Fixes

* Fix pundit policy retrieving for static pages when the pundit namespace is `:active_admin`. [#5777] by [@kwent]
* Fix show page title not being properly escaped if title's content included HTML. [#5802] by [@deivid-rodriguez]
* Revert [21b6138f] from [#5740] since it actually caused the performance in development to regress. [#5801] by [@deivid-rodriguez]

## 2.1.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.0.0..v2.1.0)

### Bug Fixes

* Ensure application gets reloaded only once. [#5740] by [@jscheid]
* Crash when rendering comments from a custom controller block. [#5758] by [@deivid-rodriguez]
* Switch `sass` dependency to `sassc-rails`, since `sass` is no longer supported and since it restores support for directly importing `css` files. [#5504] by [@deivid-rodriguez]

### Dependency Changes

* Support for ruby 2.3 has been removed. [#5751] by [@deivid-rodriguez]

## 2.0.0 [☰](https://github.com/activeadmin/activeadmin/compare/v2.0.0.rc2..v2.0.0)

_No changes_.

## 2.0.0.rc2 [☰](https://github.com/activeadmin/activeadmin/compare/v2.0.0.rc1..v2.0.0.rc2)

### Enhancements

* Require arbre `~> 1.2, >= 1.2.1`. [#5726] by [@ionut998], and [#5738] by [@deivid-rodriguez]

## 2.0.0.rc1 [☰](https://github.com/activeadmin/activeadmin/compare/v1.4.3..v2.0.0.rc1)

### Enhancements

* Add your own content to the site `<head>`, like analytics. [#5590] by [@buren]

  ```ruby
  ActiveAdmin.setup do |config|
    config.head = ''.html_safe
  end
  ```

* Consider authorization when displaying comments in show page. [#5555] by [@amiuhle]
* Add better support for rendering lists. [#5370] by [@dkniffin]
* Undeprecate `config.register_stylesheet` and `config.register_javascript` for lack of better solution for including external assets. It might be reevaluated in the future. [#5662] by [@deivid-rodriguez]

### Security Fixes

* Prevent leaking hashed passwords via user CSV export and adds a config option for sensitive attributes. [#5486] by [@chrp]

### Bug Fixes

* Fix for paginated collections with `per_page: Array, pagination_total: false`. [#5627] by [@bartoszkopinski]
* Restrict ransack requirement to >= 2.1.1 to play nice with Rails 5.2.2. [#5632] by [@deivid-rodriguez]
* Bad interpolation variables on pagination keys in Lithuanian translation. [#5631] by [@deivid-rodriguez]
* Tabs are not correctly created when using non-transliteratable characters as title. [#5650] by [@panasyuk]
* Sidebar title internationalization. [#5417] by [@WaKeMaTTa]
* `filter` labels not allowing a `Proc` to be passed. [#5418] by [@WaKeMaTTa]

### Dependency Changes

* Rails 4.2 support has been dropped. [#5104] by [@javierjulio] and [@deivid-rodriguez]
* Dependency on coffee-rails has been removed. [#5081] by [@javierjulio]
  If your application uses coffescript but was relying on ActiveAdmin to provide
  the dependency, you need to add the `coffee-script` gem to your `Gemfile` to
  restore it. If your only usage of coffescript was the
  `active_admin.js.coffee` generated by ActiveAdmin's generator, you can also
  convert that file to plain JS (`//= require active_admin/base` if you
  didn't add any stuff to it).
* Devise 3 support has been dropped. [#5608] by [@deivid-rodriguez] and [@javierjulio]
* `action_item` without a name has been removed. [#5099] by [@javierjulio]

## 1.4.3 [☰](https://github.com/activeadmin/activeadmin/compare/v1.4.2..v1.4.3)

### Bug Fixes

* Fix `form` parameter to `batch_action` no longer accepting procs. [#5611] by [@buren] and [@deivid-rodriguez]
* Fix passing a proc to `scope_to`. [#5611] by [@deivid-rodriguez]

## 1.4.2 [☰](https://github.com/activeadmin/activeadmin/compare/v1.4.1..v1.4.2)

### Bug Fixes

* Fix `input_html` filter option evaluated only once. [#5376] by [@kjeldahl]

## 1.4.1 [☰](https://github.com/activeadmin/activeadmin/compare/v1.4.0..v1.4.1)

### Bug Fixes

* Fix menu item link with method delete. [#5583] by [@tiagotex]

## 1.4.0 [☰](https://github.com/activeadmin/activeadmin/compare/v1.3.1..v1.4.0)

### Enhancements

* Add missing I18n for comments. [#5458], [#5461] by [@mauriciopasquier]
* Fix batch_actions.delete_confirmation translation in zh-CN.yml. [#5453] by [@ShallmentMo]
* Add some missing italian translations. [#5433] by [@stefsava]
* Enhance some chinese translations. [#5413] by [@shouya]
* Add missing filter predicate translations to nb. [#5357] by [@rogerkk]
* Add missing norwegian comment translations. [#5375] by [@rogerkk]
* Add missing dutch translations. [#5368] by [@dennisvdvliet]
* Add missing german translations. [#5341] by [@eikes]
* Add missing spanish translation. [#5336] by [@mconiglio]
* Add from and to predicates for russian language. [#5330] by [@glebtv]
* Fix typo in finnish translation. [#5320] by [@JiiHu]
* Add missing turkish translations. [#5295] by [@kobeumut]
* Add missing chinese translations. [#5266] by [@jasl]
* Allow proc label in datepicker input. [#5408] by [@tiagotex]
* Add `group` attribute to scopes in order to show them in grouped. [#5359] by [@leio10]
* Add missing polish translations and improve existing ones. [#5537] by [@Wowu]
* Add `priority` option to `action_item`. [#5334] by [@andreslemik]

### Bug Fixes

* Fixed the string representation of the resolved `sort_key` when no explicit `sortable` attribute is passed. [#5464] by [@chumakoff]
* Fixed docs on the column `sortable` attribute (which actually doesn't have to be explicitly specified when a block is passed to column). [#5464] by [@chumakoff]
* Fixed `if:` scope option when a lambda is passed. [#5501] by [@deivid-rodriguez]
* Comment validation adding redundant errors when resource is missing. [#5517] by [@deivid-rodriguez]
* Fixed resource filtering by association when the resource has custom primary key. [#5446] by [@wasifhossain]
* Fixed "create anoter" checkbox styling. [#5324] by [@faucct]

## 1.3.1 [☰](https://github.com/activeadmin/activeadmin/compare/v1.3.0..v1.3.1)

### Bug Fixes

* gemspec should have more permissive ransack dependency. [#5448] by [@varyonic]

## 1.3.0 [☰](https://github.com/activeadmin/activeadmin/compare/v1.2.1..v1.3.0)

### Enhancements

* Rails 5.2 support [#5343] by [@varyonic], [#5399], [#5401] by [@zorab47]

## 1.2.1 [☰](https://github.com/activeadmin/activeadmin/compare/v1.2.0..v1.2.1)

### Bug Fixes

* Resolve issue with [#5275] preventing XSS in filters sidebar. [#5299] by [@faucct]

## 1.2.0 [☰](https://github.com/activeadmin/activeadmin/compare/v1.1.0..v1.2.0)

### Enhancements

* Do not display pagination info when there are no comments. [#5119] by [@alex-bogomolov]
* Revert generated config files to pluralized. [#5120] by [@varyonic], [#5137] by [@deivid-rodriguez]
* Warn when action definition overwrites controller method. [#5167] by [@aarek]
* Better performance of comments show view. [#5208] by [@dhyegofernando]
* Mitigate memory bloat [#4118] with CSV exports. [#5251] by [@f1sherman]
* Fix issue applying custom decorations. [#5253] by [@faucct]
* Brazilian locale updated. [#5125] by [@renotocn]
* Japanese locale updated. [#5143] by [@5t111111], [#5157] by [@innparusu95]
* Italian locale updated. [#5180] by [@blocknotes]
* Swedish locale updated. [#5187] by [@jawa]
* Vietnamese locale updated. [#5194] by [@Nguyenanh]
* Esperanto locale added. [#5210] by [@RobinvanderVliet]

### Bug Fixes

* Fix a couple of issues rendering filter labels. [#5223] by [@wspurgin]
* Prevent NameError when filtering on a namespaced association. [#5240] by [@DanielHeath]
* Fix undefined method error in Ransack when building filters. [#5238] by [@wspurgin]
* Fixed [#5198] Prevent XSS on sidebar's current filter rendering. [#5275] by [@deivid-rodriguez]
* Sanitize display_name. [#5284] by [@markstory]

## 1.1.0 [☰](https://github.com/activeadmin/activeadmin/compare/v1.0.0..v1.1.0)

### Bug Fixes

* Fixed [#5093] Handle table prefix & table suffix for `ActiveAdminComment` model
* Fixed [#4173] by including the default Kaminari templates. [#5069] by [@javierjulio]
* Fixed [#5043]. Do not crash in sidebar rendering when a default scope is not specified. [#5044] by [@Fivell]
* Fixed [#3894]. Make tab's component work with non-ascii titles. [#5046] by [@Fivell]

### Dependency Changes

* Ruby 2.1 support has been dropped. [#5003] by [@deivid-rodriguez]
* Replaced `sass-rails` with `sass` dependency. [#5037] by [@javierjulio]
* Removed `jquery-ui-rails` as a dependency. [#5052] by [@javierjulio]
  The specific jQuery UI assets used are now within the vendor directory. This
  will be replaced by alternatives and dropped entirely in a major release.
  Please remove any direct inclusions of `//= require jquery-ui`. This allows us
  to upgrade to jquery v3.

### Deprecations

* Deprecated `config.register_stylesheet` and `config.register_javascript`. Import your CSS and JS files in `active_admin.scss` or `active_admin.js`. [#5060] by [@javierjulio]
* Deprecated `type` param from `status_tag` and related CSS classes [#4989] by [@javierjulio]
  The method signature has changed from:

  ```ruby
  status_tag(status, :ok, class: 'completed', label: 'on')
  ```

  to:

  ```ruby
  status_tag(status, class: 'completed ok', label: 'on')
  ```

  The following CSS classes have been deprecated and will be removed in the future:

  ```css
  .status_tag {
    &.ok, &.published, &.complete, &.completed, &.green { background: #8daa92; }
    &.warn, &.warning, &.orange { background: #e29b20; }
    &.error, &.errored, &.red { background: #d45f53; }
  }
  ```

### Enhancements

* Support proc as an input_html option value when declaring filters. [#5029] by [@Fivell]
* Base localization support, better associations handling for active filters sidebar. [#4951] by [@Fivell]
* Allow AA scopes to return paginated collections. [#4996] by [@Fivell]
* Added `scopes_show_count` configuration to  setup show_count attribute for scopes globally. [#4950] by [@Fivell]
* Allow custom panel title given with `attributes_table`. [#4940] by [@ajw725]
* Allow passing a class to `action_item` block. [#4997] by [@Fivell]
* Add pagination to the comments section. [#5088] by [@alex-bogomolov]

## 1.0.0 [☰](https://github.com/activeadmin/activeadmin/compare/v0.6.3..v1.0.0)

### Breaking Changes

* Rename `allow_comments` to `comments` for more consistent naming. [#3695] by [@pranas]
* JavaScript `window.AA` has been removed, use `window.ActiveAdmin`. [#3606] by [@timoschilling]
* `f.form_buffers` has been removed. [#3486] by [@varyonic]
* Iconic has been removed. [#3553] by [@timoschilling]
* `config.show_comments_in_menu` has been removed, see `config.comments_menu`. [#4187] by [@drn]
* Rails 3.2 & Ruby 1.9.3 support has been dropped. [#4848] by [@deivid-rodriguez]
* Ruby 2.0.0 support has been dropped. [#4851] by [@deivid-rodriguez]
* Rails 4.0 & 4.1 support has been dropped. [#4870] by [@deivid-rodriguez]

### Enhancements

* Migration from Metasearch to Ransack. [#1979] by [@seanlinsley]
* Rails 4 support. [#2326] by many people :heart:
* Rails 4.2 support. [#3731] by [@gonzedge] and [@timoschilling]
* Rails 5 support. [#4254] by [@seanlinsley]
* Rails 5.1 support. [#4882] by [@varyonic]
* "Create another" checkbox for the new resource page. [#4477] by [@bolshakov]
* Page supports belongs_to. [#4759] by [@Fivell] and [@zorab47]
* Support for custom sorting strategies. [#4768] by [@Fivell]
* Stream CSV downloads as they're generated. [#3038] by [@craigmcnamara]
* Disable streaming in development for easier debugging. [#3535] by [@seanlinsley]
* Improved code reloading. [#3783] by [@chancancode]
* Do not auto link to inaccessible actions. [#3686] by [@pranas]
* Allow to enable comments on per-resource basis. [#3695] by [@pranas]
* Unify DSL for index `actions` and `actions dropdown: true`. [#3463] by [@timoschilling]
* Add DSL method `includes` for `ActiveRecord::Relation#includes`. [#3464] by [@timoschilling]
* BOM (byte order mark) configurable for CSV download. [#3519] by [@timoschilling]
* Column block on table index is now sortable by default. [#3075] by [@dmitry]
* Allow Arbre to be used inside ActiveAdmin forms. [#3486] by [@varyonic]
* Make AA ORM-agnostic. [#2545] by [@johnnyshields]
* Add multi-record support to `attributes_table_for`. [#2544] by [@zorab47]
* Table CSS classes are now prefixed to prevent clashes. [#2532] by [@TimPetricola]
* Allow Inherited Resources shorthand for redirection. [#2001] by [@seanlinsley]

  ```ruby
  controller do
    # Redirects to index page instead of rendering updated resource
    def update
      update!{ collection_path }
    end
  end
  ```

* Accept block for download links. [#2040] by [@potatosalad]

  ```ruby
  index download_links: ->{ can?(:view_all_download_links) || [:pdf] }
  ```

* Comments menu can be customized via configuration passed to `config.comments_menu`. [#4187] by [@drn]
* Added `config.route_options` to namespace to customize routes. [#4731] by [@stereoscott]

### Security Fixes

* Prevents access to formats that the user not permitted to see. [#4867] by [@Fivell] and [@timoschilling]
* Prevents potential DOS attack via Ruby symbols. [#1926] by [@seanlinsley]
  * [this isn't an issue for those using Ruby >= 2.2](http://rubykaigi.org/2014/presentation/S-NarihiroNakamura)

### Bug Fixes

* Fixes filters for `has_many :through` relationships. [#2541] by [@shekibobo]
* "New" action item now only shows up on the index page. bf659bc by [@seanlinsley]
* Fixes comment creation bug with aliased resources. 9a082486 by [@seanlinsley]
* Fixes the deletion of `:if` and `:unless` from filters. [#2523] by [@PChambino]

### Deprecations

* `ActiveAdmin::Event` (`ActiveAdmin::EventDispatcher`). [#3435] by [@timoschilling]
  `ActiveAdmin::Event` will be removed in a future version, ActiveAdmin switched
  to use `ActiveSupport::Notifications`
  NOTE: The blog parameters has changed:

  ```ruby
  ActiveSupport::Notifications.subscribe ActiveAdmin::Application::BeforeLoadEvent do |event, *args|
    # some code
  end

  ActiveSupport::Notifications.publish ActiveAdmin::Application::BeforeLoadEvent, "some data"
  ```

* `action_item` without a name, to introduce a solution for removing action items (`remove_action_item(name)`). [#3091] by [@amiel]

## Previous Changes

Please check [0-6-stable] for previous changes.

[0-6-stable]: https://github.com/activeadmin/activeadmin/blob/0-6-stable/CHANGELOG.md

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
[#4118]: https://github.com/activeadmin/activeadmin/issues/4118
[#4173]: https://github.com/activeadmin/activeadmin/issues/4173
[#4187]: https://github.com/activeadmin/activeadmin/issues/4187
[#4254]: https://github.com/activeadmin/activeadmin/issues/4254
[#5043]: https://github.com/activeadmin/activeadmin/issues/5043
[#5198]: https://github.com/activeadmin/activeadmin/issues/5198

[21b6138f]: https://github.com/activeadmin/activeadmin/pull/5740/commits/21b6138fdcf58cd54c3f1d3f60cb1127b174b40f

[#3091]: https://github.com/activeadmin/activeadmin/pull/3091
[#3435]: https://github.com/activeadmin/activeadmin/pull/3435
[#4477]: https://github.com/activeadmin/activeadmin/pull/4477
[#4731]: https://github.com/activeadmin/activeadmin/pull/4731
[#4759]: https://github.com/activeadmin/activeadmin/pull/4759
[#4768]: https://github.com/activeadmin/activeadmin/pull/4768
[#4848]: https://github.com/activeadmin/activeadmin/pull/4848
[#4851]: https://github.com/activeadmin/activeadmin/pull/4851
[#4867]: https://github.com/activeadmin/activeadmin/pull/4867
[#4870]: https://github.com/activeadmin/activeadmin/pull/4870
[#4882]: https://github.com/activeadmin/activeadmin/pull/4882
[#4940]: https://github.com/activeadmin/activeadmin/pull/4940
[#4950]: https://github.com/activeadmin/activeadmin/pull/4950
[#4951]: https://github.com/activeadmin/activeadmin/pull/4951
[#4989]: https://github.com/activeadmin/activeadmin/pull/4989
[#4996]: https://github.com/activeadmin/activeadmin/pull/4996
[#4997]: https://github.com/activeadmin/activeadmin/pull/4997
[#5003]: https://github.com/activeadmin/activeadmin/pull/5003
[#5029]: https://github.com/activeadmin/activeadmin/pull/5029
[#5037]: https://github.com/activeadmin/activeadmin/pull/5037
[#5044]: https://github.com/activeadmin/activeadmin/pull/5044
[#5046]: https://github.com/activeadmin/activeadmin/pull/5046
[#5052]: https://github.com/activeadmin/activeadmin/pull/5052
[#5060]: https://github.com/activeadmin/activeadmin/pull/5060
[#5069]: https://github.com/activeadmin/activeadmin/pull/5069
[#5078]: https://github.com/activeadmin/activeadmin/pull/5078
[#5081]: https://github.com/activeadmin/activeadmin/pull/5081
[#5088]: https://github.com/activeadmin/activeadmin/pull/5088
[#5093]: https://github.com/activeadmin/activeadmin/pull/5093
[#5099]: https://github.com/activeadmin/activeadmin/pull/5099
[#5104]: https://github.com/activeadmin/activeadmin/pull/5104
[#5119]: https://github.com/activeadmin/activeadmin/pull/5119
[#5120]: https://github.com/activeadmin/activeadmin/pull/5120
[#5125]: https://github.com/activeadmin/activeadmin/pull/5125
[#5137]: https://github.com/activeadmin/activeadmin/pull/5137
[#5143]: https://github.com/activeadmin/activeadmin/pull/5143
[#5157]: https://github.com/activeadmin/activeadmin/pull/5157
[#5167]: https://github.com/activeadmin/activeadmin/pull/5167
[#5180]: https://github.com/activeadmin/activeadmin/pull/5180
[#5187]: https://github.com/activeadmin/activeadmin/pull/5187
[#5194]: https://github.com/activeadmin/activeadmin/pull/5194
[#5208]: https://github.com/activeadmin/activeadmin/pull/5208
[#5210]: https://github.com/activeadmin/activeadmin/pull/5210
[#5223]: https://github.com/activeadmin/activeadmin/pull/5223
[#5238]: https://github.com/activeadmin/activeadmin/pull/5238
[#5240]: https://github.com/activeadmin/activeadmin/pull/5240
[#5251]: https://github.com/activeadmin/activeadmin/pull/5251
[#5253]: https://github.com/activeadmin/activeadmin/pull/5253
[#5266]: https://github.com/activeadmin/activeadmin/pull/5266
[#5272]: https://github.com/activeadmin/activeadmin/pull/5272
[#5275]: https://github.com/activeadmin/activeadmin/pull/5275
[#5284]: https://github.com/activeadmin/activeadmin/pull/5284
[#5295]: https://github.com/activeadmin/activeadmin/pull/5295
[#5299]: https://github.com/activeadmin/activeadmin/pull/5299
[#5320]: https://github.com/activeadmin/activeadmin/pull/5320
[#5324]: https://github.com/activeadmin/activeadmin/pull/5324
[#5330]: https://github.com/activeadmin/activeadmin/pull/5330
[#5334]: https://github.com/activeadmin/activeadmin/pull/5334
[#5336]: https://github.com/activeadmin/activeadmin/pull/5336
[#5341]: https://github.com/activeadmin/activeadmin/pull/5341
[#5343]: https://github.com/activeadmin/activeadmin/pull/5343
[#5357]: https://github.com/activeadmin/activeadmin/pull/5357
[#5359]: https://github.com/activeadmin/activeadmin/pull/5359
[#5368]: https://github.com/activeadmin/activeadmin/pull/5368
[#5370]: https://github.com/activeadmin/activeadmin/pull/5370
[#5375]: https://github.com/activeadmin/activeadmin/pull/5375
[#5376]: https://github.com/activeadmin/activeadmin/pull/5376
[#5399]: https://github.com/activeadmin/activeadmin/pull/5399
[#5401]: https://github.com/activeadmin/activeadmin/pull/5401
[#5408]: https://github.com/activeadmin/activeadmin/pull/5408
[#5413]: https://github.com/activeadmin/activeadmin/pull/5413
[#5417]: https://github.com/activeadmin/activeadmin/pull/5417
[#5418]: https://github.com/activeadmin/activeadmin/pull/5418
[#5433]: https://github.com/activeadmin/activeadmin/pull/5433
[#5446]: https://github.com/activeadmin/activeadmin/pull/5446
[#5448]: https://github.com/activeadmin/activeadmin/pull/5448
[#5453]: https://github.com/activeadmin/activeadmin/pull/5453
[#5458]: https://github.com/activeadmin/activeadmin/pull/5458
[#5461]: https://github.com/activeadmin/activeadmin/pull/5461
[#5464]: https://github.com/activeadmin/activeadmin/pull/5464
[#5486]: https://github.com/activeadmin/activeadmin/pull/5486
[#5501]: https://github.com/activeadmin/activeadmin/pull/5501
[#5504]: https://github.com/activeadmin/activeadmin/pull/5504
[#5517]: https://github.com/activeadmin/activeadmin/pull/5517
[#5537]: https://github.com/activeadmin/activeadmin/pull/5537
[#5548]: https://github.com/activeadmin/activeadmin/pull/5548
[#5555]: https://github.com/activeadmin/activeadmin/pull/5555
[#5583]: https://github.com/activeadmin/activeadmin/pull/5583
[#5590]: https://github.com/activeadmin/activeadmin/pull/5590
[#5608]: https://github.com/activeadmin/activeadmin/pull/5608
[#5611]: https://github.com/activeadmin/activeadmin/pull/5611
[#5627]: https://github.com/activeadmin/activeadmin/pull/5627
[#5631]: https://github.com/activeadmin/activeadmin/pull/5631
[#5632]: https://github.com/activeadmin/activeadmin/pull/5632
[#5650]: https://github.com/activeadmin/activeadmin/pull/5650
[#5660]: https://github.com/activeadmin/activeadmin/pull/5660
[#5662]: https://github.com/activeadmin/activeadmin/pull/5662
[#5710]: https://github.com/activeadmin/activeadmin/pull/5710
[#5726]: https://github.com/activeadmin/activeadmin/pull/5726
[#5738]: https://github.com/activeadmin/activeadmin/pull/5738
[#5740]: https://github.com/activeadmin/activeadmin/pull/5740
[#5751]: https://github.com/activeadmin/activeadmin/pull/5751
[#5758]: https://github.com/activeadmin/activeadmin/pull/5758
[#5777]: https://github.com/activeadmin/activeadmin/pull/5777
[#5794]: https://github.com/activeadmin/activeadmin/pull/5794
[#5800]: https://github.com/activeadmin/activeadmin/pull/5800
[#5801]: https://github.com/activeadmin/activeadmin/pull/5801
[#5802]: https://github.com/activeadmin/activeadmin/pull/5802
[#5811]: https://github.com/activeadmin/activeadmin/pull/5811
[#5816]: https://github.com/activeadmin/activeadmin/pull/5816
[#5822]: https://github.com/activeadmin/activeadmin/pull/5822
[#5826]: https://github.com/activeadmin/activeadmin/pull/5826
[#5831]: https://github.com/activeadmin/activeadmin/pull/5831
[#5842]: https://github.com/activeadmin/activeadmin/pull/5842
[#5854]: https://github.com/activeadmin/activeadmin/pull/5854
[#5855]: https://github.com/activeadmin/activeadmin/pull/5855
[#5867]: https://github.com/activeadmin/activeadmin/pull/5867
[#5870]: https://github.com/activeadmin/activeadmin/pull/5870
[#5874]: https://github.com/activeadmin/activeadmin/pull/5874
[#5877]: https://github.com/activeadmin/activeadmin/pull/5877
[#5886]: https://github.com/activeadmin/activeadmin/pull/5886
[#5887]: https://github.com/activeadmin/activeadmin/pull/5887
[#5894]: https://github.com/activeadmin/activeadmin/pull/5894
[#5895]: https://github.com/activeadmin/activeadmin/pull/5895
[#5929]: https://github.com/activeadmin/activeadmin/pull/5929
[#5931]: https://github.com/activeadmin/activeadmin/pull/5931
[#5938]: https://github.com/activeadmin/activeadmin/pull/5938
[#5943]: https://github.com/activeadmin/activeadmin/pull/5943
[#5946]: https://github.com/activeadmin/activeadmin/pull/5946
[#5956]: https://github.com/activeadmin/activeadmin/pull/5956
[#5957]: https://github.com/activeadmin/activeadmin/pull/5957
[#5994]: https://github.com/activeadmin/activeadmin/pull/5994
[#6000]: https://github.com/activeadmin/activeadmin/pull/6000
[#6002]: https://github.com/activeadmin/activeadmin/pull/6002
[#6047]: https://github.com/activeadmin/activeadmin/pull/6047
[#6086]: https://github.com/activeadmin/activeadmin/pull/6086
[#6099]: https://github.com/activeadmin/activeadmin/pull/6099
[#6124]: https://github.com/activeadmin/activeadmin/pull/6124
[#6149]: https://github.com/activeadmin/activeadmin/pull/6149
[#6198]: https://github.com/activeadmin/activeadmin/pull/6198
[#6210]: https://github.com/activeadmin/activeadmin/pull/6210
[#6221]: https://github.com/activeadmin/activeadmin/pull/6221
[#6232]: https://github.com/activeadmin/activeadmin/pull/6232
[#6249]: https://github.com/activeadmin/activeadmin/pull/6249
[#6315]: https://github.com/activeadmin/activeadmin/pull/6315
[#6318]: https://github.com/activeadmin/activeadmin/pull/6318
[#6341]: https://github.com/activeadmin/activeadmin/pull/6341
[#6368]: https://github.com/activeadmin/activeadmin/pull/6368
[#6393]: https://github.com/activeadmin/activeadmin/pull/6393
[#6422]: https://github.com/activeadmin/activeadmin/pull/6422
[#6451]: https://github.com/activeadmin/activeadmin/pull/6451
[#6460]: https://github.com/activeadmin/activeadmin/pull/6460
[#6462]: https://github.com/activeadmin/activeadmin/pull/6462
[#6487]: https://github.com/activeadmin/activeadmin/pull/6487
[#6523]: https://github.com/activeadmin/activeadmin/pull/6523
[#6536]: https://github.com/activeadmin/activeadmin/pull/6536
[#6548]: https://github.com/activeadmin/activeadmin/pull/6548
[#6583]: https://github.com/activeadmin/activeadmin/pull/6583
[#6584]: https://github.com/activeadmin/activeadmin/pull/6584
[#6872]: https://github.com/activeadmin/activeadmin/pull/6872
[#6873]: https://github.com/activeadmin/activeadmin/pull/6873
[#6884]: https://github.com/activeadmin/activeadmin/pull/6884
[#6906]: https://github.com/activeadmin/activeadmin/pull/6906
[#6915]: https://github.com/activeadmin/activeadmin/pull/6915
[#6916]: https://github.com/activeadmin/activeadmin/pull/6916
[#6922]: https://github.com/activeadmin/activeadmin/pull/6922
[#6936]: https://github.com/activeadmin/activeadmin/pull/6936
[#6954]: https://github.com/activeadmin/activeadmin/pull/6954
[#6959]: https://github.com/activeadmin/activeadmin/pull/6959
[#7095]: https://github.com/activeadmin/activeadmin/pull/7095
[#7127]: https://github.com/activeadmin/activeadmin/pull/7127
[#7144]: https://github.com/activeadmin/activeadmin/pull/7144
[#7170]: https://github.com/activeadmin/activeadmin/pull/7170
[#7181]: https://github.com/activeadmin/activeadmin/pull/7181
[#7205]: https://github.com/activeadmin/activeadmin/pull/7205
[#7235]: https://github.com/activeadmin/activeadmin/pull/7235
[#7236]: https://github.com/activeadmin/activeadmin/pull/7236
[#7262]: https://github.com/activeadmin/activeadmin/pull/7262
[#7293]: https://github.com/activeadmin/activeadmin/pull/7293
[#7332]: https://github.com/activeadmin/activeadmin/pull/7332
[#7336]: https://github.com/activeadmin/activeadmin/pull/7336
[#7340]: https://github.com/activeadmin/activeadmin/pull/7340
[#7341]: https://github.com/activeadmin/activeadmin/pull/7341
[#7349]: https://github.com/activeadmin/activeadmin/pull/7349
[#7350]: https://github.com/activeadmin/activeadmin/pull/7350
[#7377]: https://github.com/activeadmin/activeadmin/pull/7377
[#7384]: https://github.com/activeadmin/activeadmin/pull/7384
[#7394]: https://github.com/activeadmin/activeadmin/pull/7394
[#7453]: https://github.com/activeadmin/activeadmin/pull/7453

[@1000ship]: https://github.com/1000ship
[@5t111111]: https://github.com/5t111111
[@aarek]: https://github.com/aarek
[@adler99]: https://github.com/adler99
[@agrobbin]: https://github.com/agrobbin
[@ajw725]: https://github.com/ajw725
[@alejandroperea]: https://github.com/alejandroperea
[@alex-bogomolov]: https://github.com/alex-bogomolov
[@amiel]: https://github.com/amiel
[@amiuhle]: https://github.com/amiuhle
[@andreslemik]: https://github.com/andreslemik
[@bartoszkopinski]: https://github.com/bartoszkopinski
[@blocknotes]: https://github.com/blocknotes
[@bolshakov]: https://github.com/bolshakov
[@brunvez]: https://github.com/brunvez
[@buren]: https://github.com/buren
[@chancancode]: https://github.com/chancancode
[@chrp]: https://github.com/chrp
[@chumakoff]: https://github.com/chumakoff
[@cprodhomme]: https://github.com/cprodhomme
[@craigmcnamara]: https://github.com/craigmcnamara
[@DanielHeath]: https://github.com/DanielHeath
[@deivid-rodriguez]: https://github.com/deivid-rodriguez
[@dennisvdvliet]: https://github.com/dennisvdvliet
[@dhyegofernando]: https://github.com/dhyegofernando
[@dkniffin]: https://github.com/dkniffin
[@dmitry]: https://github.com/dmitry
[@drn]: https://github.com/drn
[@eikes]: https://github.com/eikes
[@f1sherman]: https://github.com/f1sherman
[@FabioRos]: https://github.com/FabioRos
[@faucct]: https://github.com/faucct
[@Fivell]: https://github.com/Fivell
[@Fs00]: https://github.com/Fs00
[@fuzziness]: https://github.com/fuzziness
[@giapnhdev]: https://github.com/giapnhdev
[@gigorok]: https://github.com/gigorok
[@glebtv]: https://github.com/glebtv
[@gonzedge]: https://github.com/gonzedge
[@guigs]: https://github.com/guigs
[@HappyKadaver]: https://github.com/HappyKadaver
[@imcvampire]: https://github.com/imcvampire
[@innparusu95]: https://github.com/innparusu95
[@ionut998]: https://github.com/ionut998
[@irmela]: https://github.com/irmela
[@Ivanov-Anton]: https://github.com/Ivanov-Anton
[@jasl]: https://github.com/jasl
[@javawizard]: https://github.com/javawizard
[@javierjulio]: https://github.com/javierjulio
[@jawa]: https://github.com/jawa
[@jaynetics]: https://github.com/jaynetics
[@JiiHu]: https://github.com/JiiHu
[@jiikko]: https://github.com/jiikko
[@johnnyshields]: https://github.com/johnnyshields
[@jscheid]: https://github.com/jscheid
[@juril33t]: https://github.com/juril33t
[@jwesorick]: https://github.com/jwesorick
[@Karoid]: https://github.com/Karoid
[@kjeldahl]: https://github.com/kjeldahl
[@ko-lem]: https://github.com/ko-lem
[@kobeumut]: https://github.com/kobeumut
[@Kris-LIBIS]: https://github.com/Kris-LIBIS
[@krzcho]: https://github.com/krzcho
[@kwent]: https://github.com/kwent
[@leio10]: https://github.com/leio10
[@littleforest]: https://github.com/littleforest
[@Looooong]: https://github.com/Looooong
[@lubosch]: https://github.com/lubosch
[@markstory]: https://github.com/markstory
[@mauriciopasquier]: https://github.com/mauriciopasquier
[@mconiglio]: https://github.com/mconiglio
[@mgrunberg]: https://github.com/mgrunberg
[@micred]: https://github.com/micred
[@mirelon]: https://github.com/mirelon
[@MmKolodziej]: https://github.com/MmKolodziej
[@mshalaby]: https://github.com/mshalaby
[@munen]: https://github.com/munen
[@mvz]: https://github.com/mvz
[@ndbroadbent]: https://github.com/ndbroadbent
[@ngouy]: https://github.com/ngouy
[@Nguyenanh]: https://github.com/Nguyenanh
[@orkhan]: https://github.com/orkhan
[@panasyuk]: https://github.com/panasyuk
[@PChambino]: https://github.com/PChambino
[@potatosalad]: https://github.com/potatosalad
[@pranas]: https://github.com/pranas
[@renotocn]: https://github.com/renotocn
[@rn0rno]: https://github.com/rn0rno
[@RobinvanderVliet]: https://github.com/RobinvanderVliet
[@rogerkk]: https://github.com/rogerkk
[@roramirez]: https://github.com/roramirez
[@seanlinsley]: https://github.com/seanlinsley
[@sergey-alekseev]: https://github.com/sergey-alekseev
[@sgara]: https://github.com/sgara
[@ShallmentMo]: https://github.com/ShallmentMo
[@shekibobo]: https://github.com/shekibobo
[@shouya]: https://github.com/shouya
[@sjieg]: https://github.com/sjieg
[@sprql]: https://github.com/sprql
[@stefsava]: https://github.com/stefsava
[@stereoscott]: https://github.com/stereoscott
[@tagliala]: https://github.com/tagliala
[@taralbass]: https://github.com/taralbass
[@tiagotex]: https://github.com/tiagotex
[@timoschilling]: https://github.com/timoschilling
[@TimPetricola]: https://github.com/TimPetricola
[@tomgilligan]: https://github.com/tomgilligan
[@TonyArra]: https://github.com/TonyArra
[@tordans]: https://github.com/tordans
[@utkarsh2102]: https://github.com/utkarsh2102
[@varyonic]: https://github.com/varyonic
[@vcsjones]: https://github.com/vcsjones
[@vfonic]: https://github.com/vfonic
[@violeta-p]: https://github.com/violeta-p
[@vlad-psh]: https://github.com/vlad-psh
[@WaKeMaTTa]: https://github.com/WaKeMaTTa
[@wasifhossain]: https://github.com/wasifhossain
[@westonganger]: https://github.com/westonganger
[@Wowu]: https://github.com/Wowu
[@wspurgin]: https://github.com/wspurgin
[@zorab47]: https://github.com/zorab47
