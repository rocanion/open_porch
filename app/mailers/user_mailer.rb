class UserMailer < PostageApp::Mailer
  default :from => 'open_porch@example.com'

  if defined?(ActionController::Base)
    default_url_options[:host] = 'localhost:3000'
  end

  def password_reset(user)
    postageapp_template 'main_layout'
    @user = user
    mail(
      :to => user.email, 
      :subject => "You have requested a new password"
    )
  end

  def new_issue(issue)
    postageapp_template 'main_layout'
    @issue = issue
    mail(
      :subject => "#{issue.number}-#{issue.area.name}",
      :to => issue.area.users.collect(&:email)
    )
  end

  def email_verification(user)
    postageapp_template 'main_layout'
    @user = user
    mail(
      :subject => "Your account has been created. Please verify your email address",
      :to => user.email
    )
  end
  
end
