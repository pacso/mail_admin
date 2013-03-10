class PagesController < ApplicationController
  
  def index
    @mailbox = current_mailbox
    @domains = Domain.all if current_mailbox.has_role? :site_admin
  end
end
