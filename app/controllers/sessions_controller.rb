class SessionsController < ApplicationController
  skip_before_filter :authenticate, except: :destroy
  
  def new
    # Cannot sign in twice
    redirect_to root_url if current_mailbox
  end
  
  def create
    mailbox = Mailbox.find_by_email params[:mailbox][:email]
    
    if mailbox && mailbox.authenticate(params[:mailbox][:password])
      session[:mailbox_id] = mailbox.id
      redirect_to root_path
    else
      flash.now.alert = "Access Denied"
      render :new
    end
  end
  
  def destroy
    session[:mailbox_id] = nil
    redirect_to sign_in_path, notice: "Successfully signed out"
  end
end
