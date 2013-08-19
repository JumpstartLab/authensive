require 'bundler'
Bundler.require

require './config/environment'

namespace :db do
  desc "migrate your database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end