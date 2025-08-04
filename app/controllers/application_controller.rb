class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  layout :layout_by_resource

  private

  def layout_by_resource
    "application"
  end
end
