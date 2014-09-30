class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:update_users, :set_default_limit]
  before_action :assert_user_is_active, except: [:update_users, :set_default_limit]
  before_action :authenticate_admin_user!, only: [:update_users, :set_default_limit]
  inherit_resources

  def index
    @users = User.active
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments.not_archived
    find_rewards(@user)
    if params[:q] && params[:q][:s] == 'user asc'
      @received_rewards = @received_rewards.sort_by { |reward| reward.giver }
      @given_rewards = @given_rewards.sort_by { |reward| reward.recipient }
    elsif params[:q] && params[:q][:s] == 'user desc'
      @received_rewards = @received_rewards.sort_by { |reward| reward.giver }.reverse
      @given_rewards = @given_rewards.sort_by { |reward| reward.recipient }.reverse
    end
  end

  def change_period
    @users = User.active
    @month = params[:month]
    @year = params[:year]
    respond_to do |format|
      format.js
    end
  end

  def update_users
    User.where(id: params[:user][:ids]).update_all(limit: params[:user][:limit])
    redirect_to admin_users_path
  end

  def set_default_limit
    Setting[:default_limit] = params[:user][:default_limit]
    redirect_to admin_users_path
  end

  def find_rewards(user)
    @r = user.given_rewards.not_archived.search(params[:q])
    @given_rewards = @r.result(distinct: true)
    @g = user.received_rewards.not_archived.search(params[:q])
    @received_rewards = @g.result(distinct: true)
  end
end
