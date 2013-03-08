require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    context "when logged in" do
      before(:each) do
        ApplicationController.any_instance.stub(:current_mailbox).and_return(FactoryGirl.create(:mailbox))
        get :new
      end
      
      it "redirects to /" do
        response.should redirect_to root_path
      end
    end
    
    context "when logged out" do
      before { get :new }
      
      it "renders the :new template" do
        response.should render_template :new        
      end
    end
  end
  
  describe "POST #create" do
    let(:mailbox) { create(:mailbox) }
    
    context "with valid attributes for an existing account" do
      before(:each) do
        post :create, mailbox: { email: mailbox.email_address, password: mailbox.password }
      end
        
      it "assigns the mailbox.id to session[:mailbox_id]" do
        # assigns(:current_mailbox).should eq mailbox
        session[:mailbox_id].should eq mailbox.id
      end
      
      it "redirects to the homepage" do
        response.should redirect_to root_path
      end
    end
    
    context "with invalid attributes" do
      before(:each) do
        post :create, mailbox: { email: 'email@example.com', password: 'invalid' }
      end
      it "does not assign a value to session[:mailbox_id]" do
        # assigns(:current_mailbox).should_not eq mailbox
        session[:mailbox_id].should be nil
      end
      it "re-renders the :new template" do
        response.should render_template :new
      end
    end
  end
  
  describe "DELETE #destroy" do
    let(:mailbox) { create(:mailbox) }
    before { session[:mailbox_id] = mailbox.id }
    
    context "when logged in" do
      before do
        post :destroy
      end

      it "clears the mailbox_id from the session" do
        expect(session[:mailbox_id]).to be_nil
      end
      
      it "no longer returns a mailbox in current_mailbox" do
        get :new
        assigns(:current_mailbox).should be_nil
      end
    end
  end
end
