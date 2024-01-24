# config.ru
require "rack"
require "rack/session/cookie"
require_relative 'main'

use Rack::Session::Cookie, key: 'rack.session',
    path: '/',
    expire_after: 40, # Время жизни куки в секундах
    secret: 'some_very_long_and_complex_secret_string_that_is_at_least_64_bytes_long1'

run App.new
