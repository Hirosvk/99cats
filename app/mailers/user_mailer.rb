class UserMailer < ApplicationMailer
  default from: 'kjnhiroyuki@hotmail.com'

  def welcome_email(user)
    @user = user
    @url = 'http://localhost:3000/cats/'
    mail(to: user.email, subject: 'Welcome to 99 Cats')
  end
end
