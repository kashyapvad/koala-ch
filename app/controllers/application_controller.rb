class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_member
  helper_method :member_is_signed_in?, :current_member?, :member_is_signed_out?

  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  protected

  def member_access_token
    token = request.headers["HTTP_X_AUTH_TOKEN"]
    token ||= params["HTTP_X_AUTH_TOKEN"] if "OPEN".eql? ENV["BACKDOOR"]
    token
  end

  def current_member
  end

  def require_member_access_token!
    render_403 if member_access_token_required? and current_member.nil?
    current_member
  end

  # we can toggle this to true when the app is under an Auth wall.
  def member_access_token_required?
    false
  end

end
