module Authensive
  class AuthenticationServer < Sinatra::Base
    use OmniAuth::Builder do
      provider :github, Config.github_client_id, Config.github_client_secret
    end

    enable :sessions

    get '/logout' do
      session[:user_id] = nil
      redirect '/'
    end

    get '/auth/:name/callback' do
      omniauth_data = request.env["omniauth.auth"]
      user = User.create_or_login_with_omniauth(omniauth_data)
      session[:user_id] = user.id
      redirect '/'
    end

    get '/' do
      slim :root
    end

    helpers do
      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
    end

  end
end