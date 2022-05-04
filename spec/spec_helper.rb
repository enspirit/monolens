$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'monolens'
require 'path'
require 'date'
require 'json'
require 'yaml'

module Helpers
end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
