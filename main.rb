require 'rack'
require 'json'
require 'warden'

Warden::Strategies.add(:basic) do
  def valid?
    @params = JSON.parse env['rack.input'].read
    @params["email"] && @params["password"]

  end

  def authenticate!
    if @params["email"] == "admin@gmail.com" && @params["password"] == "0001"
      success! "User object"
    else
      fail!
    end
  end
end

class App
  def call(env)
    req = Rack::Request.new env

    res = Rack::Response.new
    res.set_header 'content-type', 'text/html'

    case req.path_info
    when '/'
      res.body = ['<h1>Greetings from Rack!!!!!!!!!!</h1>']
    when '/public_article/'
      res.write File.read('views/public_article.html')
    when '/protected_article/'

      session = env['rack.session']
      session ||= {}
      session[:auth] ||= {}
      if session[:auth]["email"] == "admin@gmail.com" && session[:auth]["password"] == "0001"
        res.write File.read('views/protected_article.html')
      else
        res.write "Access denied"
        res.status = 401
      end

    when '/auth/'
      res.write File.read('views/auth.html')
    when '/auth_request/'
      env['warden'].authenticate!

      session = env['rack.session']
      session ||= {}
      session[:auth] = {"email" => "admin@gmail.com", "password" => "0001"}


    else
      res.status = 404
      res.body = ['Page Not Found (']
    end

    res.finish
  end
end

