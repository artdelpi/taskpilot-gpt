class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(user_params)
      redirect_back fallback_location: authenticated_root_path, notice: "Profile updated."
    else
      redirect_back fallback_location: authenticated_root_path,
                    alert: current_user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
