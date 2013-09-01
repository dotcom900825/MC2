# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "eifion@asciicasts.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => user.login, :subject => "blog-激活帐号")
  end
end