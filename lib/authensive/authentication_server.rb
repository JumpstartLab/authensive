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
      session[:authensive_signiture] = SignatureGenerator.digest(user.id)
      if session[:callback]
        redirect "#{session[:callback]}?return_to=#{session[:return_to]}&user_id=#{user.id}&authensive_signiture=#{session[:authensive_signiture]}"
      else
        status 400
      end
    end

    get '/user/:id' do |id|
      if params['authensive_signature'] == SignatureGenerator.digest(id)
        puts "Finding User with ID #{id}: #{User.find(id).to_json}"
        User.find(id).to_json
      else
        puts "Signature mismatch for ID #{id} and param sig #{params['authensive_signature']} and calculated sig #{SignatureGenerator.digest(id)}"
        puts "Params: #{params.inspect}"
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