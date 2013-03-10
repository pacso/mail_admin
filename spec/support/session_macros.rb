module SessionMacros
  def set_current_mailbox(mailbox)
    session[:mailbox_id] = mailbox.id
  end
end