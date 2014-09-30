class AdminNotifier < ActionMailer::Base
  def new_user_notify(user)
    @user = user
    emails = AdminUser.pluck(:email).join(',')
    mail to: emails
  end

  def report(month, year)
    @users = User.active
    @month = month
    @year = year
    @subject = "Report for #{Date::MONTHNAMES[month]} #{year}"
    emails = AdminUser.pluck(:email).join(',')
    mail to: emails, subject: @subject
  end
end
