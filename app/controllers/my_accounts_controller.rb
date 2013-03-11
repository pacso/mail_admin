class MyAccountsController < ApplicationController
  
  def show
    @mailbox = current_mailbox
  end
  
  def update
    @mailbox = current_mailbox
    
    if @mailbox.update_attributes(params[:mailbox])
      redirect_to root_path, notice: "Account settings updated successfully"
    else
      render :show
    end
  end
end
