# ActionMailer::Base.smtp_settings = {
#   :address              => "smtp.exmail.qq.com",
#   :port                 => 465,
#   # :domain               => "moshifang.com",
#   :user_name            => "hello@moshifang.com",
#   :password             => "toi1pc51.6",
#   :authentication       => :login,
#   # :enable_starttls_auto => true
# }
# ActionMailer::Base.smtp_settings = {
#   :address              => "smtp.gmail.com",
#   :port                 => 587,
#   :domain               => "asciicasts.com",
#   :user_name            => "xyuanu2011",
#   :password             => "xy5277468424",
#   :authentication       => "plain",
#   :enable_starttls_auto => true
# }
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "asciicasts.com",
  :user_name            => "moshifanghello",
  :password             => "toi1pc51.5",
  :authentication       => "plain",
  :enable_starttls_auto => true
}