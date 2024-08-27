# Contributing

Thanks for your interest in contributing to ActiveAdmin! Please take a moment to review this document **before submitting a pull request**.

## Pull requests

**Please ask first before starting work on any significant new features.**

It's never a fun experience to have your pull request declined after investing a lot of time and effort into a new feature. To avoid this from happening, we request that contributors create [a feature request](https://github.com/activeadmin/activeadmin/discussions/new?category=ideas) to first discuss any new ideas. Your ideas and suggestions are welcome!

Please ensure that the tests are passing when submitting a pull request. If you're adding new features to ActiveAdmin, please include tests.

## Where do I go from here?

For any questions, support, or ideas, etc. [please create a GitHub discussion](https://github.com/activeadmin/activeadmin/discussions/new). If you've noticed a bug, [please submit an issue][new issue].

### Fork and create a branch

If this is something you think you can fix, then [fork Active Admin] and create
a branch with a descriptive name.

### Get the test suite running

Make sure you're using a recent Ruby and Node version. You'll also need Chrome installed in order to run Cucumber scenarios.

Now install the development dependencies:

```sh
gem install foreman
bundle install
yarn install
```

Now you should be able to run the entire suite using:

```sh
bin/rake
```

The task will generate a sample Rails application in `tmp/test_apps` to run the
test suite against.

If you want to test against a Rails version different from the latest, make sure
you use the correct Gemfile, for example:

```sh
export BUNDLE_GEMFILE=gemfiles/rails_61/Gemfile
```

### Implement your fix or feature

At this point, you're ready to make your changes. Feel free to ask for help.

### View your changes in a Rails application

Make sure to take a look at your changes in a browser. To boot up a test Rails app:

```sh
bin/rake local server
```

This will automatically create a Rails app if none already exists, and store it
in the `tmp/development_apps` folder.

You should now be able to open <http://localhost:3000/admin> in your browser and log in using `admin@example.com` and `password`.

If you need to perform any other commands on the test application, just pass
them to the `local` rake task. For example, to boot the rails console:

```sh
bin/rake local console
```

Or to migrate the database for a new migration:

```sh
bin/rake local db:migrate
```

### Create a Pull Request

At this point, if your changes look good and tests are passing, you are ready to create a pull request.

Github Actions will run our test suite against all supported Rails versions. It's possible that your changes pass tests in one Rails version but fail in another. In that case, you'll have to setup your development
environment with the Gemfile for the problematic Rails version, and investigate what's going on.

## Merging a PR (maintainers only)

A PR can only be merged into master by a maintainer if: CI is passing, approved by another maintainer and is up to date with the default branch. Any maintainer is allowed to merge a PR if all of these conditions ae met.

## Shipping a release (maintainers only)

Maintainers need to do the following to push out a release:

* Create a feature branch from master and make sure it's up to date.
* Run `bin/prep-release [version]` and commit the changes. Use Ruby version format. NPM is handled automatically.
* Optional: To confirm the release contents, run `gem build` (extract contents) and `npm publish --dry-run`.
* Review and merge the PR.
* Run `bin/rake release` from the default branch once the PR is merged.
* [Create a GitHub Release](https://github.com/activeadmin/activeadmin/releases/new) by selecting the tag and generating the release notes.

[new issue]: https://github.com/activeadmin/activeadmin/issues/new
