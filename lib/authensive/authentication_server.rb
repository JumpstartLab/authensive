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
      auth = request.env["omniauth.auth"]
      # user = User.first_or_create({ :uid => auth["uid"]}, {
      #   :uid => auth["uid"],
      #   :name => auth["info"]["name"], 
      #   :nickname => auth["info"]["nickname"], 
      #   :email => auth["info"]["email"], 
      #   :created_at => Time.now })
      raise auth.inspect
      session[:user_id] = user.id
      redirect '/'
    end

  end
end