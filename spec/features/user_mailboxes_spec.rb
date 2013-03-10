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
  
end