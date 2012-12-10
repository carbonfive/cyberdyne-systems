require 'capybara/cucumber'
require 'capybara/spec/test_app'

Capybara.run_server = false
Capybara.app_host = 'http://cyberdyne-systems-staging.herokuapp.com'
