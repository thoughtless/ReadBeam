class ApplicationController < ActionController::Base
  protect_from_forgery
    
  def authenticate_admin!
    unless current_user.is_admin?
      flash[:error] = "Sorry, mere mortals are not allowed here. Go play somewhere else. Incident logged."
      Rails.logger.error("Nasty user tried to admin without required credentials.")
      redirect_to root_path
    end
  end
  
  def after_sign_in_path_for(resource)
    edocs_path
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
