class AliasesController < ApplicationController
  
  def new
    @domain = current_mailbox.domain
    @alias = Alias.new
  end
  
  def create
    @domain = current_mailbox.domain
    @alias = Alias.new(params[:alias])
    
    if @alias.save
      redirect_to tabbed_home_path(:domain_admin, :aliases), notice: "Alias created successfully"
    else
      render :new
    end
  end
  
  def edit
    @domain = current_mailbox.domain
    @alias = Alias.find(params[:id])
  end
  
  def update
    @domain = current_mailbox.domain
    @alias = Alias.find(params[:id])
    
    if @alias.update_attributes(params[:alias])
      redirect_to tabbed_home_path(:domain_admin, :aliases), notice: "Alias for mailbox #{@alias.mailbox.email} updated successfully"
    else
      render :new
    end      
  end
  
  def destroy
    @domain = current_mailbox.domain
    @alias = Alias.find(params[:id])
    
    @alias.destroy
    redirect_to tabbed_home_path(:domain_admin, :aliases)
  end
end
