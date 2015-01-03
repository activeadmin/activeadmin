# Active Admin

Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.

[![Version         ](http://img.shields.io/gem/v/activeadmin.svg)                               ](https://rubygems.org/gems/activeadmin)
[![Travis CI       ](http://img.shields.io/travis/activeadmin/activeadmin/master.svg)           ](https://travis-ci.org/activeadmin/activeadmin)
[![Quality         ](http://img.shields.io/codeclimate/github/activeadmin/activeadmin.svg)      ](https://codeclimate.com/github/activeadmin/activeadmin)
[![Coverage        ](http://img.shields.io/coveralls/activeadmin/activeadmin.svg)               ](https://coveralls.io/r/activeadmin/activeadmin)
[![Gittip          ](http://img.shields.io/gittip/activeadmin.svg)                              ](https://gittip.com/activeadmin)
[![Inch CI         ](http://inch-ci.org/github/activeadmin/activeadmin.svg?branch=master)       ](http://inch-ci.org/github/activeadmin/activeadmin)
[![Stories in Ready](http://badge.waffle.io/activeadmin/activeadmin.png?label=ready&title=ready)](https://waffle.io/activeadmin/activeadmin)

## State of the project

### Rails 4.2

<<<<<<< HEAD
#### Special Branch

This branch (`rails-4-2`) is a draft to support Rails 4.2. There is no guarantee that this branch will work with Rails 4.2.
If you want to contribute to the improvement of the Rails 4.2 support, create a pull request against the `rails-4-2` branch, not against `master`!

#### Setup

To use `activeadmin` with `rails 4.2`, you need to setup your Gemfile like this:

```ruby
gem 'activeadmin', github: 'activeadmin', branch: 'rails-4-2'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'
```

#### Related Issues

Issues related to Rails 4.2 will be tagged with [`rails-4-2`](https://github.com/activeadmin/activeadmin/labels/rails-4-2).

#### Some background informations

ActiveAdmin is based on [`inherited_resources`](https://github.com/josevalim/inherited_resources), in a hard and fundamentally way. Which means thats it is a big change to remove `inherited_resources`. For ActiveAdmin `1.0` it is not an option, to remove `inherited_resources`, in my eyes. But if someone want's to do it, I will be happy to see a PR for that.

Some things about the [`Deprecation notice`](https://github.com/josevalim/inherited_resources#deprecation-notice) of `inherited_resources`:

1. The readme says `[inherited_resources] is no longer actively maintained`, that's not the full truth! [@rafaelfranca](https://github.com/rafaelfranca) has [announced](https://github.com/activeadmin/activeadmin/pull/3193#issuecomment-62421649), that he will maintain `inherited_resources` until Rails 5.0 for us! Thanks for that again btw! For Rails 5.0 we need to remove `inherited_resources` and find a own solution (there is already a [issue](https://github.com/activeadmin/activeadmin/issues/3604) for that).
2. `inherited_resources` says `I suggest developers to make use of Rails' respond_with feature alongside the responders gem as a replacement to Inherited Resources.`, this sentences is irritating! `responders` is not a full replacement of `inherited_resources`! `responders` is a dependency of `inherited_resources` for example.
=======
ActiveAdmin doesn't currently support Rails 4.2. Read [here](https://github.com/activeadmin/activeadmin/blob/rails-4-2/README.md#rails-42) for details.
>>>>>>> master

### 1.0.0

We're [currently working on 1.0.0](https://github.com/activeadmin/activeadmin/issues?milestone=18),
which as far as dependencies, moves us from meta_search to Ransack and adds Rails 4 support.
You can get Rails 4 and 4.1 support by tracking master:

```ruby
gem 'activeadmin', github: 'activeadmin'
```

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
[Iconic Icons]        | An excellent SVG icon set designed by P.J. Onori
[Inherited Resources] | Simplifies controllers with pre-built RESTful controller actions
[Kaminari]            | Elegant pagination for any sort of collection
[Ransack]             | Provides a simple search API to query your data

[Arbre]: https://github.com/activeadmin/arbre
[Devise]: https://github.com/plataformatec/devise
[Formtastic]: https://github.com/justinfrench/formtastic
[Iconic Icons]: http://somerandomdude.com/projects/iconic
[Inherited Resources]: https://github.com/josevalim/inherited_resources
[Kaminari]: https://github.com/amatsuda/kaminari
[Ransack]: https://github.com/activerecord-hackery/ransack
