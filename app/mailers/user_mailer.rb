class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  if defined?(ActionController::Base)
    default_url_options[:host] = 'open-porch.local'
  end
  
  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "[OpenPorch] You have requested a new password")
  end

  def new_issue(issue, emails = nil)
    @issue = issue
    mail(
      :subject => "[OpenPorch] #{issue.number}-#{issue.area.name}",
      :to => emails
    )
  end

  def email_verification(user)
    @user = user
    mail(
      :subject => "[OpenPorch] Your account has been created. Please verify your email address",
      :to => user.email
    )
  end
  
end
