require 'spec_helper'

describe PagesController do
  
  describe "GET #index" do
    let(:get_index) { -> { get :index} }
    
    it "requires you to be signed in" do
      get_index
      expect(response).to require_sign_in
    end
    
    context "when not logged in" do
      it "redirects to the sign_in page" do
        get :index
        response.should redirect_to sign_in_path
      end
    end
    describe "when logged in" do
      let!(:domain1) { create :domain }
      let!(:domain2) { create :domain }
      let(:mailbox) { create :mailbox, domain: domain1 }
      before(:each) do
        set_current_mailbox(mailbox)
      end
      
      context "with a standard account" do
        it "does not assign a list of domains" do
          # expect get_index.to
          assigns(:domains).should be_nil
        end
      end
      
      context "as a domain_admin" do
        let(:mailbox) { create :domain_admin_mailbox, domain: domain1 }
      end
      
      context "as a site_admin" do
        let(:mailbox) { create :site_admin_mailbox, domain: domain1 }
        
        it "assigns a list of domains" do
          get :index
          assigns(:domains).should eq [domain1, domain2]
        end
      end
      

      
      
    end
  end
end
