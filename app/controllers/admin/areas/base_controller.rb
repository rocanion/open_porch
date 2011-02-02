class Admin::Areas::BaseController < ApplicationController
  layout 'admin'
  before_check :allow_if_admin!
  before_filter :require_admin

protected
  
  def allow_if_admin!
    if (@user.is_admin?)
      allow!
    end
  end
end