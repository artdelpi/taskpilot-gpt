class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to @comment.task
    else
      render :new
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.task
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :task_id, :user_id, :author_name)
  end
end
