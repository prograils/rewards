AdminUser.first_or_create(email: ENV['REWARDTHEM_ADMIN_EMAIL'], password: ENV['REWARDTHEM_ADMIN_PASSWORD'], password_confirmation: ENV['REWARDTHEM_ADMIN_PASSWORD'])
