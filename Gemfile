source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :development do
  gem 'sqlite3'
  gem 'puma'
  gem "sprockets-rails", ">= 2.0.0"
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'webdrivers'
  gem 'turbo-rails', '~> 1.4'
end

# To use a debugger
# gem 'byebug', group: [:development, :test]

# HACK explicitly declare `coffee-script`, else Sprockets will fail to
# load it when testing multiple versions of Rails in succession, due to
# being confused by its own cache (related: rails/sprockets#183)
gem 'coffee-script'
