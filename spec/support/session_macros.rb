module SessionMacros
  def set_current_mailbox(mailbox)
    session[:mailbox_id] = mailbox.id
  end
  
  def sign_in(mailbox)
    visit root_path
    fill_in 'Email', with: mailbox.email_address
    fill_in 'Password', with: mailbox.password
    click_button 'Sign In'
  end
end