require 'spec_helper'

feature "Domain Admins" do
  given!(:domain1) { create(:domain) }
  given!(:domain2) { create(:domain) }
  given!(:mailbox) { create(:domain_admin_mailbox, domain: domain1) }
  given!(:user_mailbox1) { create(:mailbox, domain: domain1) }
  given!(:user_mailbox2) { create(:mailbox, domain: domain1) }
  given!(:other_mailbox) { create(:mailbox, domain: domain2) }
  
  background { sign_in mailbox }

  scenario "can see accounts within their domain but no others" do
    visit root_path
    click_link "Domain Accounts"
    
    expect(page).to have_content mailbox.email_address
    expect(page).to have_content user_mailbox1.email_address
    expect(page).to have_content user_mailbox2.email_address
    expect(page).to_not have_content other_mailbox.email_address
  end
end