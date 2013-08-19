module Authensive
  class Config
    def self.supported_services
      [:github]
    end

    supported_services.each do |service|
      define_singleton_method "#{service}_client_id" do
        ENV["AUTHENSIVE_#{service.to_s.upcase}_CLIENT_ID"]
      end

      define_singleton_method "#{service}_client_secret" do
        ENV["AUTHENSIVE_#{service.to_s.upcase}_CLIENT_SECRET"]
      end
    end

    def self.environment
      ENV.fetch('RACK_ENV') { 'development' }
    end

    def self.shared_secret
      ENV['AUTHENSIVE_SHARED_SECRET']
    end

    def self.database_config
      YAML.load(File.read('./config/database.yml'))[environment]
    end

    def self.establish_database_connection
      ActiveRecord::Base.establish_connection(database_config)
    end
  end
end

Authensive::Config.establish_database_connection