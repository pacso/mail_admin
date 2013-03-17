class MailboxesController < ApplicationController
  
  def new
    @domain = current_mailbox.domain
    @mailbox = @domain.mailboxes.build
    authorize! :new, @mailbox
  end
  
  def create    
    @domain = current_mailbox.domain
    @mailbox = @domain.mailboxes.build(params[:mailbox])
    authorize! :create, @mailbox
    
    if @mailbox.save
      redirect_to tabbed_home_path(:domain_admin, :accounts), notice: "Account created successfully"
    else
      render :new
    end
  end
  
  def edit
    @domain = current_mailbox.domain
    @mailbox = Mailbox.find(params[:id])
    authorize! :edit, @mailbox
  end
  
  def update
    @domain = current_mailbox.domain
    @mailbox = Mailbox.find(params[:id])
    authorize! :update, @mailbox
    
    if @mailbox.update_attributes(params[:mailbox])
      redirect_to tabbed_home_path(:domain_admin, :accounts), notice: "Account #{@mailbox.email} updated successfully"
    else
      render :edit
    end
  end
  
  def destroy
    @domain = current_mailbox.domain
    @mailbox = Mailbox.find(params[:id])
    authorize! :destroy, @mailbox
    
    @mailbox.destroy
    redirect_to tabbed_home_path(:domain_admin, :accounts)
  end
end
