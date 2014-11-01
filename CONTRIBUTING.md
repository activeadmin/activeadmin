## Contributing

First off, thank you for considering contributing to Active Admin. It's people
like you that make Active Admin such a great tool.

### 1. Where do I go from here?

If you've noticed a bug or have a question that doesn't belong on the
[mailing list](http://groups.google.com/group/activeadmin) or
[Stack Overflow](http://stackoverflow.com/questions/tagged/activeadmin),
[search the issue tracker](https://github.com/activeadmin/activeadmin/issues?q=something)
to see if someone else in the community has already created a ticket.
If not, go ahead and [make one](https://github.com/activeadmin/activeadmin/issues/new)!

### 2. Fork & create a branch

If this is something you think you can fix, then
[fork Active Admin](https://help.github.com/articles/fork-a-repo)
and create a branch with a descriptive name.

A good branch name would be (where issue #325 is the ticket you're working on):

```sh
git checkout -b 325-add-japanese-translations
```

### 3. Get the test suite running

Install the development dependencies:

```sh
bundle install
```

Now you should be able to run the entire suite using:

```sh
rake test
```

Which will generate a rails application in `spec/rails` to run the tests against.

If your tests are passing locally but they're failing on Travis, reset your test environment:

```sh
rm -rf spec/rails && bundle update
```

### 4. Implement your fix or feature

At this point, you're ready to make your changes! Feel free to ask for help;
everyone is a beginner at first :smile_cat:

### 5. View your changes in a Rails application

Active Admin is meant to be used by humans, not cucumbers. So make sure to take
a look at your changes in a browser.

To boot up a test Rails app:

```sh
script/local server
```

This will automatically create a Rails app if none already exists, and store it in the
`.test-rails-apps` folder. The currently active app is symlinked to `test-rails-app`.

If you have any Bundler issues, call the `use_rails` script then prepend
the version of rails you would like to use in an environment variable:

```sh
script/use_rails 4.0.0
RAILS=4.0.0 script/local server
```

You should now be able to open <http://localhost:3000/admin> in your browser. You can log in using:

	User: admin@example.com
	Password: password

If you need to perform any other commands on the test application, use the
`local` script. For example:

To boot the rails console:

```sh
script/local console
```

Or to migrate the database:

```sh
script/local rake db:migrate
```

### 6. Run tests against major supported rails versions

Once you've implemented your code, got the tests passing, previewed it in a
browser, you're ready to test it against multiple versions of Rails.

```sh
rake test:major_supported_rails
```

This runs our test suite against a couple of major versions of Rails.
Travis does essentially the same thing when you open a Pull Request.
We care about quality, so your PR won't be merged until all tests pass.

### 7. Make a Pull Request

At this point, you should switch back to your master branch and make sure it's
up to date with Active Admin's master branch:

```sh
git remote add upstream git@github.com:activeadmin/activeadmin.git
git checkout master
git pull upstream master
```

Then update your feature branch from your local copy of master, and push it!

```sh
git checkout 325-add-japanese-translations
git rebase master
git push --set-upstream origin 325-add-japanese-translations
```

Finally, go to GitHub and [make a Pull Request](https://help.github.com/articles/creating-a-pull-request) :D

### 8. Keeping your Pull Request updated

If a maintainer asks you to "rebase" your PR, they're saying that a lot of code
has changed, and that you need to update your branch so it's easier to merge.

To learn more about rebasing in Git, there are a lot of
[good](http://git-scm.com/book/en/Git-Branching-Rebasing)
[resources](https://help.github.com/articles/interactive-rebase),
but here's the suggested workflow:

```sh
git checkout 325-add-japanese-translations
git pull --rebase upstream master
git push -f 325-add-japanese-translations
```
