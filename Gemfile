source "https://rubygems.org"
ruby "2.1.5"

gem "protected_attributes"

gem "aasm"
gem "active_model_serializers", "~> 0.8.0"
gem "ancestry"
gem "auto_strip_attributes", "~> 2.0"
gem "bootstrap-kaminari-views"
gem "bootstrap-sass"
gem "bootstrap_form"
gem "coffee-rails", "~> 4.0.0"
gem "delayed_job_active_record"
gem "devise"
gem "enumerize"
gem "figaro"
gem "friendly_id", "~> 5.0.3"
gem "geocoder"
gem "haml-rails", "~> 0.5.3"
gem "jquery-rails"
gem "kaminari"
gem "neat"
gem "newrelic_rpm"
gem "passenger"
gem "pg"
gem "pg_search"
gem "platform-api"
gem "rack-cors", require: "rack/cors"
gem "rack-timeout"
gem "rails", "~> 4.1.1"
gem "sass-rails", "~> 4.0.3"
gem "simple_form"
gem "uglifier", ">= 1.3.0"

group :production, :staging do
  gem "rails_12factor"
end

group :test, :development do
  gem "rspec-rails", "~> 3.0.0"
  gem "factory_girl_rails", ">= 4.2.0"
  gem "bullet"
end

group :test do
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "capybara"
  gem "poltergeist"
  gem "shoulda-matchers", require: false
  gem "coveralls", require: false
  gem "rubocop"
  gem "webmock"
end

group :development do
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", platforms: [:mri_19, :rbx]
  gem "spring"
  gem "spring-commands-rspec"
  gem "listen", "~> 1.0"
end
