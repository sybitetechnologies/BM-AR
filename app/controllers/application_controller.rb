class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  include DeviseTokenAuth::Concerns::SetUserByToken

  def current_user
  	current_api_user
  end
end
