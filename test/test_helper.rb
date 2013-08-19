gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require 'bundler'
Bundler.require

require './lib/authensive'

require 'database_cleaner'
DatabaseCleaner.strategy = :transaction

class Minitest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end