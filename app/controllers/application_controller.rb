class ApplicationController < ActionController::Base
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  protect_from_forgery
  
  before_filter :authenticate
  
  private
  
  # Override CanCan defaults
  def current_ability
    @current_ability ||= MailboxAbility.new(current_mailbox)
  end
  
  def authenticate
    unless current_mailbox
      session[:requested_url] = request.url
      redirect_to sign_in_path, :alert => 'You must sign in to access this page'
    end
  end
  
  def current_mailbox
    @current_mailbox ||= Mailbox.find(session[:mailbox_id]) if session[:mailbox_id]
  end
  helper_method :current_mailbox
end
