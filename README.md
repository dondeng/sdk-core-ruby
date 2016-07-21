This is the MasterCard OpenAPI Ruby Core SDK

# Configure
gem build *.gemspec
gem install mastercard_api_core-1.0.0.gem
gem install ci_reporter_minitest

# Run Tests

### Normal Tests

`rake test`

### Test With Coverage

`COVERAGE=true rake test`

### Test With XML Report
`rake report`
