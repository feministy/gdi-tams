Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.raise_runtime_errors = true


  # Mailtrap
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "http://localhost:3000" }
  config.action_mailer.smtp_settings = {
    :user_name => '20848c62d28739702',
    :password => 'eb6bea007c4395',
    :address => 'mailtrap.io',
    :domain => 'mailtrap.io',
    :port => '2525',
    :authentication => :cram_md5,
    :enable_starttls_auto => true
  }
end
