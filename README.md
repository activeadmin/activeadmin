# Active Admin

[Active Admin](https://activeadmin.info) is a Ruby on Rails framework for
creating elegant backends for website administration.

[![Version         ][rubygems_badge]][rubygems]
[![Circle CI       ][circle_badge]][circle]
[![Coverage        ][coverage_badge]][coverage]
[![Tidelift        ][tidelift_badge]][tidelift]
[![Inch CI         ][inch_badge]][inch]

## Goals

* Enable developers to quickly create good-looking administration interfaces.
* Build a DSL for developers and an interface for businesses.
* Ensure that developers can easily customize every nook and cranny.

## Getting started

* Check out [the docs][docs].
* Try the [live demo][demo].
* The [wiki] includes links to tutorials, articles and sample projects.

## Need help?

Please use [StackOverflow][stackoverflow] for help requests and how-to questions.

Please open GitHub issues for bugs and enhancements only, not general help requests.
Please search previous issues (and Google and StackOverflow) before creating a new issue.

Google Groups, IRC #activeadmin and Gitter are not actively monitored.

## Want to contribute?

This project exists thanks to all the people who contribute, so thank you!

If you want to contribute through code or documentation, the [contributing
guide][contributing] is a good place to start. If you have questions, feel free
to ask.

If you want to contribute economically, you can help funding the project
through a [Tidelift subscription][tidelift]. By buying a Tidelift subscription
you make sure your whole dependency stack is properly maintained, while also
getting a comprenhensive view of outdated dependencies, new releases, security
alerts, and licensing compatibility issues.

You can also support us with a weekly tip via [Liberapay].

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

[rubygems_badge]: http://img.shields.io/gem/v/activeadmin.svg
[rubygems]: https://rubygems.org/gems/activeadmin
[circle_badge]: https://circleci.com/gh/activeadmin/activeadmin/tree/master.svg
[circle]: https://circleci.com/gh/activeadmin/activeadmin/tree/master
[coverage_badge]: https://api.codeclimate.com/v1/badges/779e407d22bacff19733/test_coverage
[coverage]: https://codeclimate.com/github/activeadmin/activeadmin/test_coverage
[inch_badge]: http://inch-ci.org/github/activeadmin/activeadmin.svg?branch=master
[inch]: http://inch-ci.org/github/activeadmin/activeadmin
[tidelift_badge]: https://tidelift.com/badges/github/activeadmin/activeadmin
[tidelift]: https://tidelift.com/subscription/pkg/rubygems-activeadmin?utm_source=rubygems-activeadmin&utm_medium=readme

[docs]: http://activeadmin.info/0-installation.html
[demo]: http://demo.activeadmin.info/admin
[wiki]: https://github.com/activeadmin/activeadmin/wiki
[stackoverflow]: http://stackoverflow.com/questions/tagged/activeadmin
[contributing]: https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md
[Liberapay]: https://liberapay.com
