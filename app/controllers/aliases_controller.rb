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
end
