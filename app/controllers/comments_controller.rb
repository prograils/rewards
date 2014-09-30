class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :assert_user_is_active
  inherit_resources

  def create
    @comment = current_user.comments.create(comment_params)
    @comment.reward_id = params[:reward_id]
    @comment.save
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:description)
  end
end
