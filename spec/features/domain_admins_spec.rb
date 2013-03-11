require 'spec_helper'

feature "Domain Admins" do
  given!(:domain1) { create(:domain) }
  given!(:domain2) { create(:domain) }
  given!(:mailbox) { create(:domain_admin_mailbox, domain: domain1) }
  given!(:user_mailbox_1) { create(:mailbox, domain: domain1) }
  given!(:user_mailbox_2) { create(:mailbox, domain: domain1) }
  given!(:other_mailbox) { create(:mailbox, domain: domain2) }
  
  background { sign_in mailbox }

  scenario "can see accounts within their domain but no others" do
    visit root_path
    click_link "Domain Accounts"
    
    expect(page).to have_content mailbox.email_address
    expect(page).to have_content user_mailbox_1.email_address
    expect(page).to have_content user_mailbox_2.email_address
    expect(page).to_not have_content other_mailbox.email_address
  end
  
  scenario "can create a new account within their domain" do
    visit root_path
    click_link "Domain Accounts"
    click_link "Edit Accounts"
    expect(current_path).to eq domain_mailboxes_path
    
    click_link "Create New Account"
    expect(current_path).to eq new_domain_mailbox_path
    
    
    expect{ fill_in "Email", with: "new_account"
            fill_in "mailbox_password", with: "new_pass"
            fill_in "mailbox_password_confirmation", with: "new_pass"
            click_button "Save"}.to change(Mailbox, :count).by(1)    
    expect(current_path).to eq domain_mailboxes_path
    expect(page).to have_content "Account created"
    expect(page).to have_content "new_account@#{domain1.name}"
  end
  
  scenario "can edit an account within their domain" do
    visit root_path
    click_link "Domain Accounts"
    click_link "Edit Accounts"
    expect(page).to_not have_content('6.6')
    
    click_link user_mailbox_2.email_address
    fill_in "mailbox_delete_spam_threshold", with: 6.6
    click_button "Save"
    
    expect(current_path).to eq domain_mailboxes_path
    expect(page).to have_content("Account #{user_mailbox_2.email_address} updated successfully")
    expect(page).to have_content('6.6')
  end
end