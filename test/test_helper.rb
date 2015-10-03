require 'bundler/setup'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'dragonfly/mongoid_data_store'
require 'rubygems'
require 'database_cleaner'

if ENV["CI"]
  require "coveralls"
  Coveralls.wear!
end

Mongoid.configure do |config|
  config.connect_to('dragonfly-mongoid_data_store_test')
end

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }
end
