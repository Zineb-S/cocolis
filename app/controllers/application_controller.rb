class ApplicationController < ActionController::Base
  include Pagy::Backend
  protected
  def after_sign_in_path_for(resource)
    if resource.instance_of?(Admin)
      authenticated_admin_root_path
    else
      case resource.role
      when 'client'
        client_dashboard_path
      when 'driver'
        driver_dashboard_path
      else
        super
      end
    end
  end
end
