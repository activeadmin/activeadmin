# Upgrading ActiveAdmin v3

To update within v3, keep the major version constrained in your `Gemfile`:

```ruby
gem 'activeadmin', '~> 3.0'
```

Then run `bundle update activeadmin` and review the
[v3 changelog](https://github.com/activeadmin/activeadmin/blob/v3.5.2/CHANGELOG.md).

Moving to v4 requires changes to your assets, configuration, and custom views.
Read the [v4 beta upgrade guide](../upgrading.md) before updating the major version.
