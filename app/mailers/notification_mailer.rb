class NotificationMailer < ActionMailer::Base
#  default from: 'notifications@example.com'
 
  def added_surgeons_email(surgeon, admin_email)
    @surgeon = surgeon
    mail(to: admin_email, subject: 'A new surgeon has been added!')
  end
  
  def added_location_email(location, admin_email)
    @location = location
    mail(to: admin_email, subject: 'A new location has been added!')
  end

end