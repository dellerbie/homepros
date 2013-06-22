class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :hide_search
  
  def hide_search
    @hide_search = true
  end
end
