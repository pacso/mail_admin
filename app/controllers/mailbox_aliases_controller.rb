class MailboxAliasesController < ApplicationController
  
  def new
    @domain = current_mailbox.domain
    @mailbox_alias = MailboxAlias.new
  end
  
  def create
    @domain = current_mailbox.domain
    @mailbox_alias = MailboxAlias.new(params[:mailbox_alias])
    
    if @mailbox_alias.save
      redirect_to tabbed_home_path(:domain_admin, :aliases), notice: "Alias created successfully"
    else
      render :new
    end
  end
  
  def edit
    @domain = current_mailbox.domain
    @mailbox_alias = MailboxAlias.find(params[:id])
  end
  
  def update
    @domain = current_mailbox.domain
    @mailbox_alias = MailboxAlias.find(params[:id])
    
    if @mailbox_alias.update_attributes(params[:mailbox_alias])
      redirect_to tabbed_home_path(:domain_admin, :aliases), notice: "Alias for mailbox #{@mailbox_alias.mailbox.email} updated successfully"
    else
      render :new
    end      
  end
  
  def destroy
    @domain = current_mailbox.domain
    @mailbox_alias = MailboxAlias.find(params[:id])
    
    @mailbox_alias.destroy
    redirect_to tabbed_home_path(:domain_admin, :aliases)
  end
end
