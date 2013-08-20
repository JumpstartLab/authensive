module Authensive
  class User < ActiveRecord::Base
    def self.create_or_login_with_omniauth(data)
      User.find_or_create_by_provider_and_uid( OmniAuthFormatter.format(data) )
    end
  end

  class SignatureGenerator
    def self.digest(id)
      Digest::MD5.hexdigest( "authensive_user_#{id}_" + Config.shared_secret )
    end
  end

  class OmniAuthFormatter
    def self.format(data)
      {
        :provider => data['provider'],
        :uid      => data['uid'],
        :nickname => data['info']['nickname'],
        :email    => data['info']['email'],
        :name     => data['info']['name'],
        :image    => data['info']['image']
      }
    end
  end
end