source 'https://rubygems.org'

gem 'volt', '0.9.5.pre3'

# volt uses mongo as the default data store.
gem 'volt-mongo', '~> 0.1.0'

gem "parslet" , github: "salama/parslet"
gem "salama" , github: "salama/salama"
gem "salama-reader" , github: "salama/salama-reader"
gem "salama-arm" , github: "salama/salama-arm"
gem "salama-object-file" , github: "salama/salama-object-file"
gem "susy" , "2.2.5"

# Asset compilation gems, they will be required when needed.
gem 'csso-rails', '~> 0.3.4', require: false
gem 'uglifier', '>= 2.4.0', require: false

group :test do
  # Testing dependencies
  gem "minitest"
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
