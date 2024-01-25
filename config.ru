# config.ru
require "rack"
require "rack/session/cookie"
require_relative 'main'
require "warden"

use Rack::Session::Cookie, key: 'rack.session',
    path: '/',
    expire_after: 40, # Время жизни куки в секундах
    secret: 'some_very_long_and_complex_secret_string_that_is_at_least_64_bytes_long12'

use Warden::Manager do |manager|
  manager.default_strategies :basic
  manager.failure_app = -> env { [401, {"content-type" => "text/html"}, ["<h1>Unauthorized</h1>"]] }
end

run App.new
