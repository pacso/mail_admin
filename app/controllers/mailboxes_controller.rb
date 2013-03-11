class MailboxesController < ApplicationController
  
  def index
    @domain = current_mailbox.domain #params[:domain_id].present? ? Domain.find(params[:domain_id]) : current_mailbox.domain
    @mailboxes = @domain.mailboxes
  end
  
  def new
    @domain = current_mailbox.domain
    @mailbox = @domain.mailboxes.build
  end
  
  def create    
    @domain = current_mailbox.domain
    @mailbox = @domain.mailboxes.build(params[:mailbox])
    
    if @mailbox.save
      redirect_to domain_mailboxes_path, notice: "Account created successfully"
    else
      render :new
    end
  end
end
