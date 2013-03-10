require 'spec_helper'

describe PagesController do
  
  describe "GET #index" do
    let!(:domain1) { create :domain }
    let!(:domain2) { create :domain }
    let(:get_index) { -> { get :index} }
    
    it "requires you to be signed in" do
      get :index
      expect(response).to require_sign_in
    end
    
    context "as a standard user" do
      let(:mailbox) { create :mailbox, domain: domain1 }
      before { set_current_mailbox mailbox }
      
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end
      
      it "does not assign a list of domains" do
        get :index
        expect(assigns(:domains)).to be_nil
      end
    end
    
    context "as a domain_admin" do
      let(:mailbox) { create :domain_admin_mailbox, domain: domain1 }
      before { set_current_mailbox mailbox }
      
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end

      it "does not assign a list of domains" do
        get :index
        expect(assigns(:domains)).to be_nil
      end
    end
    
    context "as a site_admin" do
      let(:mailbox) { create :site_admin_mailbox, domain: domain1 }
      before { set_current_mailbox mailbox }
      
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end

      it "assigns a list of domains" do
        get :index
        expect(assigns(:domains)).to match_array [domain1, domain2]
      end
    end
  end
end
