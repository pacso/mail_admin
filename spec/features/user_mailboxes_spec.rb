require 'spec_helper'

feature "User Mailboxes" do
  given(:mailbox) { create(:mailbox) }
  
  background do
    sign_in mailbox
  end

  scenario "user modifies their own account" do
    visit root_path
    click_link "Edit my account"
    expect(current_path).to eq my_account_path
    
    fill_in "Move spam threshold", with: 1.6
    fill_in "Delete spam threshold", with: 8.4
    click_button "Save Settings"
    
    expect(current_path).to eq root_path
    expect(page).to have_content "settings updated"
    expect(page).to have_content Regexp.new(/spam score of 1.6.+to be filtered/)
    expect(page).to have_content Regexp.new(/spam score of 8.4.+for deletion/)
  end
  
  given(:old_password) { mailbox.password }
  given(:new_password) { 'new_password' }

  scenario "user changes their password" do
    visit root_path
    click_link "Change Password"
    
    fill_in "Existing Password", with: old_password
    fill_in "mailbox_password", with: new_password
    fill_in "mailbox_password_confirmation", with: new_password
    click_button "Change Password"
    
    expect(page).to have_content "Password changed"
    
    click_link "Sign Out"
    expect(page).to have_content "signed out"
    
    visit root_path
    expect(current_path).to eq sign_in_path
    
    sign_in_with(mailbox.email_address, old_password)
    expect(page).to have_content "Access Denied"
    expect(current_path).to eq sign_in_path
    
    sign_in_with(mailbox.email_address, new_password)
    expect(page).to have_content "Logged in as #{mailbox.email_address}"
    expect(current_path).to eq root_path
  end
  
end