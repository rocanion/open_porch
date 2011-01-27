class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  default_url_options[:host] = 'open-porch.local'

  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "You have requested a new password")
  end

  def new_post(post)
    @post = post
    mail(
      :subject => "New post for #{post.area.name}",
      :to => post.area.users.collect(&:email)
    )
  end
  
end
