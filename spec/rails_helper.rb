# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'coveralls'
Coveralls.wear!('rails')

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

require "support/wait_for_ajax"

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

Rails.logger.level = 4

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::FormHelpers, type: :feature
  config.include Requests::RequestHelpers, type: :request
  config.include DefaultHeaders, type: :request

  # rspec-rails 3+ will no longer automatically infer an example group's spec
  # type from the file location. You can explicitly opt-in to this feature by
  # uncommenting the setting below.
  config.infer_spec_type_from_file_location!

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = '#{::Rails.root}/spec/fixtures'

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  # require 'active_record_spec_helper'
end
