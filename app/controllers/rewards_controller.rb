class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :assert_user_is_active
  inherit_resources

  def index
    @reward = current_user.given_rewards.new
    @rewards = Reward.ordered.page(params[:page])
  end

  def create
    @reward = current_user.given_rewards.create(reward_params)
    if @reward.persisted?
      redirect_to root_path
    else
      render action: 'new'
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:description, :value, :recipient_id)
  end
end
