[![Stories in Ready](https://badge.waffle.io/activeadmin/activeadmin.png?label=ready&title=Ready)](https://waffle.io/activeadmin/activeadmin)
# Active Admin

[Active Admin](https://www.activeadmin.info) is a Ruby on Rails framework for creating elegant backends for website administration.

[![Version         ](http://img.shields.io/gem/v/activeadmin.svg)                               ](https://rubygems.org/gems/activeadmin)
[![Travis CI       ](http://img.shields.io/travis/activeadmin/activeadmin/master.svg)           ](https://travis-ci.org/activeadmin/activeadmin)
[![Quality         ](http://img.shields.io/codeclimate/github/activeadmin/activeadmin.svg)      ](https://codeclimate.com/github/activeadmin/activeadmin)
[![Coverage        ](https://codecov.io/gh/activeadmin/activeadmin/branch/master/graph/badge.svg)](https://codecov.io/gh/activeadmin/activeadmin)
[![Inch CI         ](http://inch-ci.org/github/activeadmin/activeadmin.svg?branch=master)       ](http://inch-ci.org/github/activeadmin/activeadmin)

## State of the project

1.0.0.pre5 is the last release to support Rails 3.2 and Ruby 2.0 or earlier.
It is provided to help with upgrades to Rails 4 only.

1.0.0.pre5 has support for Rails 5. The following Gemfile addition may be needed:

```ruby
gem 'inherited_resources', '~> 1.7'
```

1.0.0 will drop support for Rails 3.2 and Ruby 2.0 or earlier.

## Goals

1. Enable developers to quickly create good-looking administration interfaces.
2. Build a DSL for developers and an interface for businesses.
3. Ensure that developers can easily customize every nook and cranny.

## Getting started

* Check out [the docs](http://activeadmin.info/0-installation.html)!
* Try the [live demo](http://demo.activeadmin.info/admin)
* The [wiki](https://github.com/activeadmin/activeadmin/wiki) includes links to tutorials, articles and sample projects.

## Need help?

Please use [StackOverflow](http://stackoverflow.com/questions/tagged/activeadmin) for
help requests and how-to questions.

Please open GitHub issues for bugs and enhancements only, not general help requests.
Please search previous issues (and Google and StackOverflow) before creating a new issue.

Google Groups, IRC #activeadmin and Gitter are not actively monitored.

## Want to contribute?

The [contributing guide](https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md)
is a good place to start. If you have questions, feel free to ask.

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
[Inherited Resources]: https://github.com/activeadmin/inherited_resources
[Kaminari]: https://github.com/kaminari/kaminari
[Ransack]: https://github.com/activerecord-hackery/ransack
