# Active Admin

Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.

[![Version         ](http://img.shields.io/gem/v/activeadmin.svg)                               ](https://rubygems.org/gems/activeadmin)
[![Travis CI       ](http://img.shields.io/travis/activeadmin/activeadmin/master.svg)           ](https://travis-ci.org/activeadmin/activeadmin)
[![Quality         ](http://img.shields.io/codeclimate/github/activeadmin/activeadmin.svg)      ](https://codeclimate.com/github/activeadmin/activeadmin)
[![Coverage        ](http://img.shields.io/coveralls/activeadmin/activeadmin.svg)               ](https://coveralls.io/r/activeadmin/activeadmin)
[![Inch CI         ](http://inch-ci.org/github/activeadmin/activeadmin.svg?branch=master)       ](http://inch-ci.org/github/activeadmin/activeadmin)

## State of the project

### 1.0.0

We're [currently working on 1.0.0](https://github.com/activeadmin/activeadmin/issues?milestone=18),
which as far as dependencies, moves us from meta_search to Ransack and adds Rails 4 & 5 support.

You can get it by tracking master:
```ruby
gem 'activeadmin', github: 'activeadmin'
```

Or you can using rubygems:
```ruby
gem 'activeadmin', '~> 1.0.0.pre2'
```

*Keep in mind that during the time where we use `pre`-release label, things can break in each release!*

### Rails 5

Active Admin master has preliminary support for Rails 5. To give it a try, these Gemfile changes may be needed:

```ruby
gem 'devise',      '> 4.x'
gem 'rspec-rails', '>= 3.5.0.beta1'
gem 'ransack',    github: 'activerecord-hackery/ransack'
gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
gem 'formtastic', github: 'justinfrench/formtastic'
gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'
# To fix a Draper deprecation error
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
# Optional -- only if you already include these gems
gem 'rack-mini-profiler',          github: 'MiniProfiler/rack-mini-profiler'
gem 'database_cleaner',            github: 'pschambacher/database_cleaner', branch: 'rails5.0', ref: '8dd9fa4'
# Only for JRuby:
gem 'activerecord-jdbc-adapter',   github: 'jruby/activerecord-jdbc-adapter', platforms: :jruby
```

If something isn't working for you please report it on [#4177](https://github.com/activeadmin/activeadmin/issues/4177).

### 0.6.x

The plan is to follow [semantic versioning](http://semver.org/) as of 1.0.0. The 0.6.x line will
still be maintained, and we will backport bug fixes into future 0.6.x releases. If you don't want
to have to wait for a release, you can track the branch instead:

```ruby
gem 'activeadmin', github: 'activeadmin', branch: '0-6-stable'
```

## Documentation

Please note that <http://activeadmin.info> is out of date. For the latest docs, check out the
Github [docs](https://github.com/activeadmin/activeadmin/tree/master/docs#activeadmin-documentation) and the [wiki](https://github.com/activeadmin/activeadmin/wiki).

## Links

* Website: <http://www.activeadmin.info> (out of date)
* Live demo: <http://demo.activeadmin.info/admin>
* Documentation
  * Guides: <https://github.com/activeadmin/activeadmin/tree/master/docs>
  * YARD: <http://rubydoc.info/gems/activeadmin>
  * Wiki: <https://github.com/activeadmin/activeadmin/wiki>

## Goals

1. Enable developers to quickly create good-looking administration interfaces.
2. Build a DSL for developers and an interface for businesses.
3. Ensure that developers can easily customize every nook and cranny.

## Getting started

Check out [the docs](https://github.com/activeadmin/activeadmin/blob/master/docs/0-installation.md)!

## Need help?

Ask us in IRC ([#activeadmin](https://webchat.freenode.net/?channels=activeadmin)), on the
[mailing list](http://groups.google.com/group/activeadmin), or on
[Stack Overflow](http://stackoverflow.com/questions/tagged/activeadmin).

## Want to contribute?

The [contributing guide](https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md)
is a good place to start. If you have questions, feel free to ask
[@seanlinsley](https://twitter.com/seanlinsley) or [@captainhagbard](https://twitter.com/captainhagbard).

## Dependencies

We try not to reinvent the wheel, so Active Admin is built with other open source projects:

Tool                  | Description
--------------------- | -----------
[Arbre]               | Ruby -> HTML, just like that.
[Devise]              | Powerful, extensible user authentication
[Formtastic]          | A Rails form builder plugin with semantically rich and accessible markup
[Inherited Resources] | Simplifies controllers with pre-built RESTful controller actions
[Kaminari]            | Elegant pagination for any sort of collection
[Ransack]             | Provides a simple search API to query your data

[Arbre]: https://github.com/activeadmin/arbre
[Devise]: https://github.com/plataformatec/devise
[Formtastic]: https://github.com/justinfrench/formtastic
[Inherited Resources]: https://github.com/josevalim/inherited_resources
[Kaminari]: https://github.com/amatsuda/kaminari
[Ransack]: https://github.com/activerecord-hackery/ransack
