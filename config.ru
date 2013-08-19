require 'bundler'
Bundler.require

require './config/environment'

require 'sinatra/base'
require 'puma'

require './lib/authensive'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Authensive::AuthenticationServer