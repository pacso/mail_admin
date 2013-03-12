require 'spec_helper'

feature "Domain Admins" do
  given!(:domain1) { create(:domain) }
  given!(:domain2) { create(:domain) }
  given!(:mailbox) { create(:domain_admin_mailbox, domain: domain1) }
  given!(:user_mailbox_1) { create(:mailbox, domain: domain1) }
  given!(:user_mailbox_2) { create(:mailbox, domain: domain1) }
  given!(:user_mailbox_1_alias) { create(:alias, mailbox: user_mailbox_1) }
  given!(:other_mailbox) { create(:mailbox, domain: domain2) }
  
  background { sign_in mailbox }

  scenario "can see accounts within their domain but no others" do
    visit root_path
    click_link "Domain Admin"
    
    expect(page).to have_content mailbox.email
    expect(page).to have_content user_mailbox_1.email
    expect(page).to have_content user_mailbox_2.email
    expect(page).to_not have_content other_mailbox.email
  end
  
  scenario "can create a new account within their domain" do
    visit root_path
    click_link "Domain Admin"
    
    click_link "Create New Account"
    expect(current_path).to eq new_domain_mailbox_path
    
    
    expect{ fill_in "Email", with: "new_account"
            fill_in "mailbox_password", with: "new_pass"
            fill_in "mailbox_password_confirmation", with: "new_pass"
            click_button "Save"}.to change(Mailbox, :count).by(1)    
    expect(current_path).to eq tabbed_home_path(:domain_admin, :accounts)
    expect(page).to have_content "Account created"
    expect(page).to have_content "new_account@#{domain1.name}"
  end
  
  scenario "can edit an account within their domain" do
    visit root_path
    click_link "Domain Admin"
    expect(page).to_not have_content('6.6')
    
    click_link user_mailbox_2.email
    fill_in "mailbox_delete_spam_threshold", with: 6.6
    click_button "Save"
    
    expect(current_path).to eq tabbed_home_path(:domain_admin, :accounts)
    expect(page).to have_content("Account #{user_mailbox_2.email} updated successfully")
    expect(page).to have_content('6.6')
  end
  
  scenario "cannot edit an account within another domain" do
    visit edit_domain_mailbox_path(other_mailbox)
    expect(current_path).to_not eq edit_domain_mailbox_path(other_mailbox)
  end
  
  scenario "can delete an account from their domain" do #, js: true do
    visit root_path
    click_link "Domain Admin"
    expect(page).to have_css("#accounts table tbody tr", count: 3)
    
    click_link user_mailbox_2.email
    expect{ click_button "Delete Account" }.to change(Mailbox, :count).by(-1)
    expect(current_path).to eq tabbed_home_path(:domain_admin, :accounts)
    expect(page).to have_css("#accounts table tbody tr", count: 2)
    expect(page).to_not have_content user_mailbox_2.email
  end
  
  scenario "can not delete their own account" do
    visit root_path
    click_link "Domain Admin"
    within(:css, "#accounts table") { click_link mailbox.email }
    expect(page).to_not have_button("Delete Account")
  end
  
  scenario "can create aliases within their domain" do
    visit root_path
    click_link "Domain Admin"
    click_link "Aliases"
    
    click_link "Create New Alias"
    expect(current_path).to eq new_domain_alias_path
    
    expect{ fill_in "Email", with: "new_alias"
            select user_mailbox_1.email, from: 'Mailbox'
            click_button "Save"}.to change(Alias, :count).by(1)    
            
    expect(current_path).to eq tabbed_home_path(:domain_admin, :aliases)
    expect(page).to have_content "Alias created"
    expect(page).to have_content "new_alias@#{domain1.name}"
    
    click_link "Accounts"
    expect(page).to have_css("#accounts table", text: "new_alias@#{user_mailbox_1.domain.name}")
  end
  
  scenario "can edit an alias within thier domain" do
    visit root_path
    click_link "Domain Admin"
    click_link "Aliases"
    
    expect(page).to have_content user_mailbox_1_alias.email
    click_link user_mailbox_1_alias.email
    
    fill_in "Email", with: "updated_alias"
    click_button "Save"
    
    expect(current_path).to eq tabbed_home_path(:domain_admin, :aliases)
    expect(page).to have_content("Alias for mailbox #{user_mailbox_1.email} updated successfully")
    expect(page).to have_content "updated_alias@#{user_mailbox_1.domain.name}"
    expect(page).to_not have_content user_mailbox_1_alias.email
  end
  
  scenario "can delete an alias from their domain" do #, js: true do
    visit root_path
    click_link "Domain Admin"
    click_link "Aliases"
    expect(page).to have_css("#aliases table tbody tr", count: 1)
    
    click_link user_mailbox_1_alias.email
    expect{ click_button "Delete Alias" }.to change(Alias, :count).by(-1)
    expect(current_path).to eq tabbed_home_path(:domain_admin, :aliases)
    expect(page).to have_css("#aliases table tbody tr", count: 0)
    expect(page).to_not have_content user_mailbox_1_alias.email
  end
  
end
