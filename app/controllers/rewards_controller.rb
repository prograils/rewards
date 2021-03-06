class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :assert_user_is_active
  inherit_resources

  def index
    @rewards = Reward.ordered.page(params[:page])
    @recipients = User.active.where.not(id: current_user.id).to_recipients_json
  end

  def create
    @reward = current_user.given_rewards.create(reward_params)
    if @reward.persisted?
      respond_to do |format|
        format.html do
          redirect_to root_path
        end
        format.json
        format.js
      end
    else
      respond_to do |format|
        format.html do
          render action: 'new'
        end
        format.json { render status: 400 }
        format.js
      end
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:description, :value, :recipient_id)
  end
end
