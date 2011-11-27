## Contributing

This is a guide to contributing to Active Admin. It should walk you through the
major steps to contributing code to the project.

### 1. Create an Issue on Github

The first step to contributing to Active Admin is creating a ticket in our
[ticketing system on Github](https://github.com/gregbell/active_admin/issues).
The community has been hard at work already, so please take a second to search
for the issue or feature before creating a new one.

All features or bug fixes should have a ticket. This makes it easy for everyone
to discuss the code and know if a fix is already in progress for an issue. If
it's a feature, the team can prioritize what it should work on based on these
tickets.


### 2. Fork & Create a Feature Branch

The next step is to fork Active Admin (if you haven't already done so) and
create a new git branch based on the feature or issue you're working on. Please
use a descriptive name for your branch.

For example a great branch name would be (where issue #325 is the ticket you're
working on):

    $> git checkout -b 325-add-japanese-translations


### 3. Get the test suite running

Active Admin is a gem that many people and businesses rely on for managing data 
in their production applications. Bugs are not cool. Although we're not perfect,
we pride ourselves on writing well tested code. I hope you do too :)

Active Admin uses rspec and cucumber for it's test suite.

Make sure you have a recent version of bundler:

    $> gem install bundler

Then install the development the development dependencies:

    $> bundle install

Now you should be able to run the entire suite using:

    $> rake test

`rake test` runs the unit specs, integration specs and cucumber scenarios. The
test suite will generate a rails application in `spec/rails` to run the tests
against.


### 4. Implement your fix or feature

At this point, you should be ready to implement your feature!


### 5. View your changes in a Rails application

Active Admin is meant to be used by humans, not cucumbers. So make sure to take
a look at your changes in a browser (preferably a few browsers if you made view
changes).

To boot up a test rails application, use the provided script:

    $> ./script/local server

This will generate a rails application at ./test-rails-app with some sane
defaults and use your local version of Active Admin.

If you have any Bundler issues, call the provided `use_rails` script then prepend
the version of rails you would like to use in an environment variable:

    $> ./script/use_rails 3.1.0
    $> RAILS=3.1.0 ./script/local server

You should be able to open `http://localhost:3000/admin` and view a test
environment.

If you need to perform any other commands on the test application, use the
`local` script. For example to boot the rails console:

    $> ./script/local console

Or to migrate the database:

    $> ./script/local rake db:migrate


### 6. Run tests against major supported rails versions

Once you've implemented your code, got the tests passing, previewed it in a
browser, you're ready to test it against multiple versions of Rails.

    $> rake test:major_supported_rails

This command runs the cukes and specs against a couple of major versions of
Rails.  We will run this command when we review your pull request, if this 
rake task isn't passing, the pull request will not be merged in.


### 7. Make a pull request

At this point, you should switch back to your master branch and make sure it's
up to date with Active Admin's master branch. If there were any changes, you
should rebase your feature branch and make sure that it will merge correctly. If
there are any merge conflicts, your pull request will not be merged in.

Now push your changes up to your feature branch on github and make a pull request!
We will pull your changes, run the test suite, review the code and merge it in.
