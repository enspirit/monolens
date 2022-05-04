$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'monolens'

module Helpers
end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
