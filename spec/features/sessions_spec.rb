require 'spec_helper'

describe "Sessions" do
  subject { page }
  let(:sign_in) { "Sign In" }
  
  describe "sign in page" do
    before { visit sign_in_path }
    
    it { should have_selector('legend', text: sign_in) }
  end
  
  describe "sign in" do
    before { visit sign_in_path }
    
    describe "with no details" do
      before { click_button sign_in }
      
      it { should have_content "Access Denied" }
      its(:current_path) { should eq sign_in_path }
    end
    
    describe "with invalid details" do
      before do
        fill_in "Email", with: Faker::Internet.email
        fill_in "Password", with: "randomtext"
        click_button sign_in
      end
      it { should have_content "Access Denied" }
      its(:current_path) { should eq sign_in_path }
    end
    
    describe "with valid details" do
      before do
        fill_in "Email", with: mailbox.email_address
        fill_in "Password", with: mailbox.password
        click_button sign_in
      end
      
      describe "against an enabled account" do        
        let(:mailbox) { FactoryGirl.create(:mailbox) }
        it { should have_link "Sign Out" }
        its(:current_path) { should eq homepage_path }
        
        describe "followed by sign out" do
          before { click_link "Sign Out" }

          it { should_not have_link "Logout" }
          it { should have_content "Successfully signed out" }
          its(:current_path) { should eq root_path }
        end
      end
      
      describe "against a disabled account" do
        let(:mailbox) { FactoryGirl.create(:disabled_mailbox) }
        it { should_not have_link "Sign Out" }
        it { should have_content "Access Denied" }
        its(:current_path) { should eq sign_in_path }
      end

    end
  end
  
  # describe "sign_out" do
  #   let(:mailbox) { FactoryGirl.create(:mailbox) }
  # 
  #   before do
  #     ApplicationController.any_instance.stub(:current_mailbox).and_return(mailbox)
  #     visit root_path
  #     click_link "Sign Out"
  #   end
  #   
  #   it { should_not have_link "Sign Out" }
  #   it { should have_content "Successfully signed out" }
  #   its(:current_path) { should eq root_path }
  # end
end
