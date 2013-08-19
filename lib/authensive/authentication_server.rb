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

    get '/login' do
      session[:callback] = params["callback"]
      session[:return_to] = params["return_to"]
      redirect '/auth/github'
    end

    get '/auth/:name/callback' do
      user = User.create_or_login_with_omniauth request.env["omniauth.auth"]
      session[:user_id] = user.id
      sig_input = "authensive_user_#{user.id}_" + Config.shared_secret
      sig_output = session[:authensive_signiture] = Digest::MD5.hexdigest(sig_input)
      if session[:callback]
        redirect "#{session[:callback]}?return_to=#{session[:return_to]}&user_id=#{user.id}&authensive_signiture=#{session[:authensive_signiture]}"
      else
        status 400
      end
    end

    get '/user/:id' do |id|
      sig_input = "authensive_user_#{id}_" + Config.shared_secret
      if params[:authensive_signiture] == Digest::MD5.hexdigest(sig_input)
        User.find(id).to_json
      else
        status 400
      end
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