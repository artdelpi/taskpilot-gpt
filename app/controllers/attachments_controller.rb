class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new(attachment_params)
    if @attachment.save
      redirect_to @attachment.task
    else
      render :new
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to @attachment.task
  end

  private

  def attachment_params
    params.require(:attachment).permit(:task_id, :file)
  end
end
