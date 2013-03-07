class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def current_mailbox
    @current_mailbox ||= Mailbox.find(session[:mailbox_id]) if session[:mailbox_id]
  end
  helper_method :current_mailbox
end
