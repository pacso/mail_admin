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
  end
end
