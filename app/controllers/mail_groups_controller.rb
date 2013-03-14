class MailGroupsController < ApplicationController
  
  def new
    @domain = current_mailbox.domain
    @mail_group = @domain.mail_groups.build
  end
  
  def create
    @domain = current_mailbox.domain
    @mail_group = @domain.mail_groups.build(params[:mail_group])
    
    if @mail_group.save
      redirect_to tabbed_home_path(:domain_admin, :mail_groups), notice: "Mail Group created successfully"
    else
      render :new
    end
  end
  
  def edit
    @domain = current_mailbox.domain
    @mail_group = MailGroup.find(params[:id])
  end
  
  def update
    @domain = current_mailbox.domain
    @mail_group = MailGroup.find(params[:id])
    
    if @mail_group.update_attributes(params[:mail_group])
      redirect_to tabbed_home_path(:domain_admin, :mail_groups), notice: "Mail Group updated successfully"
    else
      render :edit
    end
  end
  
  def destroy
    @mail_group = MailGroup.find(params[:id])
    @mail_group.destroy
    redirect_to tabbed_home_path(:domain_admin, :mail_groups)
  end
end
