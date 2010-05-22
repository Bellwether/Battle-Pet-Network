# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.gem 'reek'
config.gem 'bullet', :source => 'http://gemcutter.org'

require 'reek/adapters/rake_task'

Reek::RakeTask.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

config.after_initialize do
  Bullet.enable = true 
  Bullet.alert = false
  Bullet.bullet_logger = true  
  Bullet.console = false
  Bullet.growl = false
  Bullet.rails_logger = true
  Bullet.disable_browser_cache = true

  ActiveMerchant::Billing::Base.mode = :test
  paypal_options = {
    :login => "cmd_1268360324_biz_api1.battlepet.net",
    :password => "1268360330",
    :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31A3Yn9CXgd7OsPfHVy2z3A2K0rWdC"
  }
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
end
