class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_from_cookie
  
end
