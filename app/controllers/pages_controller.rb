class PagesController < ApplicationController
  
  def index
    @mailbox = current_mailbox
    @mailboxes = current_mailbox.domain.mailboxes if current_mailbox.has_role? :domain_admin
    @domains = Domain.all if current_mailbox.has_role? :site_admin
  end
end
