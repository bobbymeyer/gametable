# SimpleCov Documentation

## Overview
SimpleCov is a code coverage analysis tool for Ruby. It uses Ruby's built-in Coverage library to gather code coverage data and provides a beautiful HTML report.

## Installation

1. Add to your Gemfile:
```ruby
group :test do
  gem 'simplecov', require: false
end
```

2. Run bundle install:
```bash
bundle install
```

3. Add to test/test_helper.rb:
```ruby
require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Libraries', 'lib'
end
```

## Configuration

### Minimum Coverage Threshold
Create `.simplecov` in your project root:
```ruby
require 'simplecov'

SimpleCov.minimum_coverage 90
SimpleCov.minimum_coverage_by_file 80
SimpleCov.refuse_coverage_drop
```

### Coverage Groups
```ruby
SimpleCov.start do
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Libraries', 'lib'
end
```

### Filtering
```ruby
SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter do |src|
    src.filename =~ /_spec.rb$/ # filter specs
  end
end
```

## Usage

### Running Tests with Coverage
```bash
# Run all tests with coverage
bundle exec rails test

# Run specific test file with coverage
bundle exec rails test test/models/user_test.rb
```

### Viewing Reports
After running tests, open `coverage/index.html` in your browser to view the coverage report.

## Best Practices

1. Set minimum coverage thresholds
2. Group related files together
3. Filter out non-application code
4. Track coverage trends over time
5. Integrate with CI/CD pipeline
6. Use branch coverage when possible
7. Document coverage requirements
8. Review coverage reports regularly

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Test Coverage
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:latest
        env:
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
      - name: Install dependencies
        run: bundle install
      - name: Run tests
        run: bundle exec rails test
      - name: Upload coverage
        uses: actions/upload-artifact@v2
        with:
          name: coverage
          path: coverage/
```

## Troubleshooting

### Common Issues

1. **Coverage not showing**:
   - Check if SimpleCov is required before any application code
   - Verify test files are being executed
   - Check for conflicting coverage tools

2. **Incorrect coverage numbers**:
   - Verify filters are correctly configured
   - Check for preloaded files
   - Ensure all test files are being run

3. **Slow test execution**:
   - Use appropriate filters
   - Consider parallel testing
   - Optimize test suite

### Debugging Tips

1. Check SimpleCov configuration
2. Verify test execution order
3. Inspect coverage directory
4. Check for preloaded files

## Resources

- [SimpleCov GitHub Repository](https://github.com/simplecov-ruby/simplecov)
- [SimpleCov Documentation](https://github.com/simplecov-ruby/simplecov#readme)
- [Ruby Coverage Documentation](https://docs.ruby-lang.org/en/master/Coverage.html) 