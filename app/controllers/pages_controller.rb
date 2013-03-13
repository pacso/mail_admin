class PagesController < ApplicationController
  
  def index
    @my_account = current_mailbox
    @mailboxes = current_mailbox.domain.mailboxes if current_mailbox.has_role? :domain_admin
    @mailbox_aliases = current_mailbox.domain.mailbox_aliases if current_mailbox.has_role? :domain_admin
    @domains = Domain.all if current_mailbox.has_role? :site_admin
  end
end
