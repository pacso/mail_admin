class SessionsController < ApplicationController
  skip_before_filter :authenticate, except: :new
  
  def new
    redirect_to homepage_path if current_mailbox
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
    @current_mailbox = nil
    redirect_to root_path, notice: "Successfully signed out"
  end
end
