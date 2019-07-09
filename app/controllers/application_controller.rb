class ApplicationController < ActionController::API
  include Knock::Authenticable

  protected

  def authorize_delete
    return_unauthorized unless !current_user.nil?
  end
end
