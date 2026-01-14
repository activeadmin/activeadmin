# Active Admin - GitHub Copilot Instructions

## Project Overview

Active Admin is a Ruby on Rails framework for creating elegant backends for website administration. It provides a DSL for developers to quickly create good-looking administration interfaces.

## Technology Stack

- **Backend**: Ruby on Rails (currently Rails ~> 8.1.0)
- **Frontend**: JavaScript (ES6+), Tailwind CSS, Flowbite
- **Testing**: RSpec (unit tests), Cucumber (feature tests), Capybara (integration tests)
- **Build Tools**: Rollup (JavaScript bundling), cssbundling-rails
- **Key Dependencies**: Devise (authentication), Ransack (search), Formtastic (forms), Kaminari (pagination)

## Ruby Conventions

- Minimum Ruby version: 3.2+ (required)
- Minimum Rails version: 7.2+ (required by gemspec)
- Current development uses Rails ~> 8.1.0
- Follow RuboCop style guide (configuration in `.rubocop.yml`)
- RuboCop plugins enabled: capybara, packaging, performance, rails, rspec
- Use frozen string literals: `# frozen_string_literal: true` at the top of Ruby files

## JavaScript Conventions

- Use ES6+ modern JavaScript syntax
- Follow ESLint configuration (see `eslint.config.js`)
- JavaScript source files are in `app/javascript/`
- Build JavaScript with: `npm run build`
- Lint JavaScript with: `npm run lint`

## Testing Guidelines

### Ruby Tests (RSpec)
- Unit tests are in `spec/unit/`
- Request specs are in `spec/requests/`
- Helper specs are in `spec/helpers/`
- Run RSpec tests: `bundle exec rspec`

### Feature Tests (Cucumber)
- Cucumber features are in `features/`
- Uses Capybara with Cuprite (headless Chrome)
- Cucumber scenarios require Chrome to be installed
- Run Cucumber tests: `bundle exec cucumber`
- Lint Gherkin files: `npm run gherkin-lint`

### Running All Tests
- Run the complete test suite: `bin/rake`
- Tests run against a sample Rails app generated in `tmp/test_apps/`

## Building and Development

### Setup
```bash
bundle install
yarn install
```

Note: The `bin/rake local server` command requires foreman, which it will invoke automatically. Install with `gem install foreman` if needed.

### Testing Against Different Rails Versions
```bash
# Available versions: rails_72, rails_80
export BUNDLE_GEMFILE=gemfiles/rails_72/Gemfile
```

### Local Development Server
```bash
bin/rake local server
# Visit http://localhost:3000/admin
# Login: admin@example.com / password
```

### Other Local Commands
```bash
bin/rake local console      # Rails console
bin/rake local db:migrate   # Run migrations
```

## Code Organization

- `lib/active_admin/` - Core framework code
- `app/` - Rails application components (controllers, helpers, views, assets)
- `spec/` - RSpec tests
- `features/` - Cucumber feature tests
- `docs/` - VitePress documentation (run with `npm run docs:dev`)

## Important Guidelines

1. **Minimal Changes**: Make surgical, precise changes. Don't refactor unrelated code.
2. **Backward Compatibility**: Active Admin is a widely-used gem. Maintain backward compatibility unless explicitly breaking changes are intended.
3. **Test Coverage**: Include tests for new features. Follow existing test patterns.
4. **Documentation**: Update documentation in `docs/` if adding user-facing features.
5. **Internationalization**: Support i18n - translation files are in `config/locales/`
6. **Security**: This is an authentication/authorization framework - be extra cautious with security implications.
7. **Code Quality**: Always run `bundle exec rubocop` before submitting any PR to ensure code follows project style guidelines.

## Contributing Workflow

1. Create feature request discussion before starting significant new features
2. Fork and create a descriptive branch
3. Ensure tests pass: `bin/rake`
4. Run linting: `bundle exec rubocop` for Ruby code, `npm run lint` for JavaScript
5. View changes in browser: `bin/rake local server`
6. Submit pull request with passing CI

## Release Process (Maintainers Only)

1. Create feature branch from master
2. Run `bin/prep-release [version]` and commit
3. Merge PR
4. Run `bin/rake release` from master branch
5. Create GitHub Release from tag

## Additional Context

- This is both a Ruby gem and an npm package
- Published to RubyGems as `activeadmin`
- Published to npm as `@activeadmin/activeadmin`
- The project uses both Ruby and JavaScript tooling
- CI runs tests against multiple Rails versions
- Code coverage tracked with SimpleCov and CodeCov
