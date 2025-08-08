module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def update_resource(resource, params)
      email_changed   = params[:email].present? && params[:email] != resource.email
      password_fields = params[:password].present? || params[:password_confirmation].present?

      if email_changed || password_fields
        super
      else
        params.delete(:current_password)
        resource.update_without_password(params)
      end
    end

    def after_update_path_for(resource)
      request.referer || authenticated_root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update,
        keys: [:name, :email, :password, :password_confirmation, :current_password]
      )
    end
  end
end