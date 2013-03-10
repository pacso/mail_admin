class PagesController < ApplicationController
  
  def index
    @domains = Domain.all if current_mailbox.has_role? :site_admin
  end
end
