namespace :rewardthem do
  desc 'Generate raport for previous month and archive rewards'
  task close_previous_month: :environment do |t, args|
    after_end_date = Time.new(Time.now.year, Time.now.month, 1, 0, 0)
    start_date = after_end_date - 1.month
    AdminNotifier.report(start_date.month, start_date.year).deliver
    Reward.where(created_at: start_date...after_end_date).update_all(is_archived: true)
  end
end
