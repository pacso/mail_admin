class PagesController < ApplicationController
  
  def index
    @my_account = current_mailbox

    if current_mailbox.has_role? :domain_admin
      @mailboxes = current_mailbox.domain.mailboxes.includes(:mailbox_aliases)
      @mailbox_aliases = current_mailbox.domain.mailbox_aliases
      @mail_groups = current_mailbox.domain.mail_groups
    end

    @domains = Domain.all if current_mailbox.has_role? :site_admin
  end
end
