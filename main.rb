require 'rack'
require 'json'

class App
  def call(env)
    login_data = {email: "admin@gmail.com", password: "0001"}
    req = Rack::Request.new env

    res = Rack::Response.new
    res.set_header 'Content-Type', 'text/html'

    case req.path_info
    when '/'
      res.body = ['<h1>Greetings from Rack!!!!!!!!!!</h1>']
    when '/public_article/'
      res.write File.read('views/public_article.html')
    when '/protected_article/'
      session = env['rack.session']
      session ||= {}
      puts session
      if session[:auth] == login_data
        res.write File.read('views/protected_article.html')
      else
        res.status = 403
        res.body = ['Access denied.']
      end
    when '/auth/'
      res.write File.read('views/auth.html')
    when '/auth_request/'
      req_data_json = req.body.read
      req_data = JSON.parse(req_data_json)

      email = req_data['email']
      password = req_data['password']

      if email.strip == login_data[:email] && password == login_data[:password]
        res.write({email: email, password: password}.to_json)
        puts login_data

        session = env['rack.session']
        session ||= {}
        session[:auth] = login_data
      else
        res.status = 401
      end

    else
      res.status = 404
      res.body = ['Page Not Found (']
    end

    res.finish
  end
end

# run App
