require 'spec_helper'

describe "Sessions" do
  subject { page }
  
  describe "sign in page" do
    before { visit sign_in_path }
    
    it { should have_selector('legend', text: 'Sign In') }
  end
  
  describe "sign in" do
    before { visit sign_in_path }
    
    describe "with invalid details" do
      before { click_button "Sign In" }
      
      it { should have_content "Access Denied" }
      its(:current_path) { should eq sign_in_path }
    end
    
    describe "with valid details" do
      let(:mailbox) { FactoryGirl.create(:mailbox) }
      before do
        fill_in "Email", with: mailbox.email_address
        fill_in "Password", with: mailbox.password
        click_button "Sign In"
      end
      
      it { should have_link "Logout" }
      its(:current_path) { should eq root_path }
    end
  end
end
