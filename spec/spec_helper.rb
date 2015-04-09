require "webmock/rspec"

RSpec.configure do |config|
  config.order = :random
end

WebMock.disable_net_connect!
