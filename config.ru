require 'bundler'
Bundler.require

require 'sinatra/base'
require 'puma'

require './lib/authensive'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Authensive::AuthenticationServer