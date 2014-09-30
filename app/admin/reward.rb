ActiveAdmin.register Reward do
  batch_action :archive do |selection|
    Reward.find(selection).each do |reward|
      reward.update_attributes(is_archived: true) unless reward.is_archived?
    end
    redirect_to :back
  end

  controller do
    def permitted_params
      params.permit reward: [:giver_id, :recipient_id, :description, :value, :is_archived]
    end
  end
end
