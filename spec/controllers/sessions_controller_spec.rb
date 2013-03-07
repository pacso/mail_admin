require 'spec_helper'

describe SessionsController do
  describe "GET 'new'" do
    it "displays sign_in form when logged out" do
      get :new
      response.should render_template 'new'
    end
    
    it "redirects to homepage when logged in" do
      ApplicationController.any_instance.stub(:current_mailbox).and_return(FactoryGirl.create(:mailbox))
      get :new
      response.should redirect_to(homepage_path)
    end
  end
  
end
