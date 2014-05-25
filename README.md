# Active Admin

Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.

[![Version     ](http://img.shields.io/gem/v/activeadmin.svg)                       ](https://rubygems.org/gems/activeadmin)
[![Dependencies](http://img.shields.io/gemnasium/gregbell/active_admin.svg)         ](https://gemnasium.com/gregbell/active_admin)
[![Travis CI   ](http://img.shields.io/travis/gregbell/active_admin/master.svg)     ](https://travis-ci.org/gregbell/active_admin)
[![Quality     ](http://img.shields.io/codeclimate/github/gregbell/active_admin.svg)](https://codeclimate.com/github/gregbell/active_admin)
[![Coverage    ](http://img.shields.io/coveralls/gregbell/active_admin.svg)         ](https://coveralls.io/r/gregbell/active_admin)
[![Gittip      ](http://img.shields.io/gittip/activeadmin.svg)                      ](https://gittip.com/activeadmin)

## State of the project

### 1.0.0

We're [currently working on 1.0.0](https://github.com/gregbell/active_admin/issues?milestone=18),
which as far as dependencies, moves us from meta_search to Ransack and adds Rails 4 support.
You can get Rails 4 and 4.1 support by tracking master:

```ruby
gem 'activeadmin', github: 'gregbell/active_admin'
```

### 0.6.x

The plan is to follow [semantic versioning](http://semver.org/) as of 1.0.0. The 0.6.x line will
still be maintained, and we will backport bug fixes into future 0.6.x releases. If you don't want
to have to wait for a release, you can track the branch instead:

```ruby
gem 'activeadmin', github: 'gregbell/active_admin', branch: '0-6-stable'
```

## Documentation

Please note that <http://activeadmin.info> is out of date. For the latest docs, check out the
Github [docs folder](https://github.com/gregbell/active_admin/tree/master/docs) and the [wiki](https://github.com/gregbell/active_admin/wiki).

## Links

* Website: <http://www.activeadmin.info>
* Live demo: <http://demo.activeadmin.info/admin>
* Documentation
  * Guides: <http://activeadmin.info/documentation.html>
  * YARD: <http://rubydoc.info/gems/activeadmin/frames>
  * Wiki: <https://github.com/gregbell/active_admin/wiki>

## Goals

1. Allow developers to quickly create gorgeous administration interfaces __(Not Just CRUD)__
2. Build a DSL for developers and an interface for businesses.
3. Ensure that developers can easily customize every nook and cranny of the interface.
4. Build common interfaces as shareable gems so that the entire community benefits.

## Getting started

Check out [the docs](https://github.com/gregbell/active_admin/blob/master/docs/0-installation.md)!

## Need help?

Ask us in IRC ([#activeadmin](https://webchat.freenode.net/?channels=activeadmin)), on the
[mailing list](http://groups.google.com/group/activeadmin), or on
[Stack Overflow](http://stackoverflow.com/questions/tagged/activeadmin).

## Want to contribute?

The [contributing guide](https://github.com/gregbell/active_admin/blob/master/CONTRIBUTING.md)
is a good place to start. If you have questions, feel free to ask
[@seanlinsley](https://twitter.com/seanlinsley).

## Dependencies

We try not to reinvent the wheel, so Active Admin is built with other open source projects:

Tool                  | Description
--------------------- | -----------
[Arbre]               | Ruby -> HTML, just like that.
[Devise]              | Powerful, extensible user authentication
[Formtastic]          | A Rails form builder plugin with semantically rich and accessible markup
[Iconic Icons]        | An excellent SVG icon set designed by P.J. Onori
[Inherited Resources] | Simplifies controllers with pre-built RESTful controller actions
[Kaminari]            | Elegant pagination for any sort of collection
[Ransack]             | Provides a simple search API to query your data

[Arbre]: https://github.com/gregbell/arbre
[Devise]: https://github.com/plataformatec/devise
[Formtastic]: https://github.com/justinfrench/formtastic
[Iconic Icons]: http://somerandomdude.com/projects/iconic
[Inherited Resources]: https://github.com/josevalim/inherited_resources
[Kaminari]: https://github.com/amatsuda/kaminari
[Ransack]: https://github.com/activerecord-hackery/ransack
