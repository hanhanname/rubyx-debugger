source 'https://rubygems.org'

gem 'volt', :path => "../volt"

# volt uses mongo as the default data store.
gem 'volt-mongo', '~> 0.1.0'

# The following gem's are optional for themeing
# Twitter bootstrap
gem 'volt-bootstrap', '~> 0.0.10'

# Asset compilation gems, they will be required when needed.
gem 'csso-rails', '~> 0.3.4', require: false
gem 'uglifier', '>= 2.4.0', require: false

gem "parslet" , path: "../parslet"
#gem "salama" , path: "../salama"
gem "salama-reader" , path: "../salama-reader"
gem "salama-object-file" , path: "../salama-object-file"


group :test do
  # Testing dependencies
  gem 'rspec', '~> 3.2.0'
  gem 'opal-rspec', '~> 0.4.2'
  gem 'capybara', '~> 2.4.2'
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'chromedriver2-helper', '~> 0.0.8'
  gem 'poltergeist', '~> 1.5.0'
end

# Server for MRI
platform :mri, :mingw do
  # The implementation of ReadWriteLock in Volt uses concurrent ruby and ext helps performance.
  gem 'concurrent-ruby-ext', '~> 0.8.0'

  # Thin is the default volt server, Puma is also supported
  gem 'thin', '~> 1.6.0'
  gem 'bson_ext', '~> 1.9.0'
end
