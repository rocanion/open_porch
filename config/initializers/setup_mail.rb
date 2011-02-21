email_file = File.expand_path('../email.yml', File.dirname(__FILE__))

if File.exists?(email_file)
  email_config = YAML::load(File.open(email_file))[defined?(Rails) ? Rails.env : RAILS_ENV]

  if email_config.present?
    # The mail server used to send out your emails
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
      :address              => email_config['address'],
      :port                 => email_config['port'],
      :domain               => email_config['domain'],
      :user_name            => email_config['user_name'],
      :password             => email_config['password'],
      :authentication       => email_config['authentication'],
      :enable_starttls_auto => email_config['enable_starttls_auto']
    }
  end
end