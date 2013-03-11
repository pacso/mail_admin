require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    context "when logged in" do
      let(:mailbox) { create(:mailbox) }
      before(:each) do
        set_current_mailbox(mailbox)
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
        post :create, mailbox: { email: mailbox.email, password: mailbox.password }
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
    context "when logged in" do
      let(:mailbox) { create(:mailbox) }
      before do
        set_current_mailbox(mailbox)
        post :destroy
      end

      it "clears the mailbox_id from the session" do
        expect(session[:mailbox_id]).to be_nil
      end
      
      it "redirects to the sign_in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
