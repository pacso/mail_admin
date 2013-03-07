class SessionsController < ApplicationController
  skip_before_filter :authenticate
  
  def new

  end
  
  def create
    mailbox = Mailbox.find_by_email params[:mailbox][:email]
    
    if mailbox && mailbox.authenticate(params[:mailbox][:password])
      session[:mailbox_id] = mailbox.id
      redirect_to root_url
    else
      redirect_to sign_in_path, alert: "Access Denied"
    end
  end
end
