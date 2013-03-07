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
      
      it { should have_link "Sign Out" }
      its(:current_path) { should eq root_path }
      
      describe "followed by sign out" do
        before { click_link "Sign Out" }
        
        it { should_not have_link "Logout" }
        it { should have_content "Successfully signed out" }
        its(:current_path) { should eq root_path }
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
