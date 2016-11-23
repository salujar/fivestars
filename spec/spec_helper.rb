require 'json'
require 'byebug'
require 'rspec'
require 'httparty'
require 'logger'

require_relative '../lib/fivestars'

RSpec.configure do |config|
  config.filter_run_excluding in_development: true
end