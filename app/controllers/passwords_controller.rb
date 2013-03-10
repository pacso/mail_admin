class PasswordsController < ApplicationController
  
  def new
    @mailbox = current_mailbox
  end
  
  def update
    @mailbox = current_mailbox
    
    if @mailbox.authenticate(params[:mailbox][:old_password]) && @mailbox.update_attributes({password: params[:mailbox][:password], password_confirmation: params[:mailbox][:password_confirmation]})
      redirect_to root_path, notice: "Password changed"
    else
      render :new
    end
  end
end
