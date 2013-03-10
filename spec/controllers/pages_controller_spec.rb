require 'spec_helper'

describe PagesController do
  let!(:domain1) { create :domain }
  let!(:domain2) { create :domain }
  
  shared_examples("standard template rendering") do
    describe "GET #index" do
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  
  describe "when signed out" do
    it "requires you to sign in" do
      get :index
      expect(response).to require_sign_in
    end
  end
  
  describe "when signed in" do
    before(:each) do
      set_current_mailbox mailbox
    end
    
    describe "as a standard user" do
      let(:mailbox) { create(:mailbox, domain: domain1) }
      it_behaves_like "standard template rendering"

      it "does not assign a list of domains" do
        get :index
        expect(assigns(:domains)).to be_nil
      end
    end

    describe "as a domain admin" do
      let(:mailbox) { create(:domain_admin_mailbox, domain: domain1) }
      it_behaves_like "standard template rendering"

      it "does not assign a list of domains" do
        get :index
        expect(assigns(:domains)).to be_nil
      end
    end

    describe "as a site admin" do
      let(:mailbox) { create(:site_admin_mailbox, domain: domain1) }
      it_behaves_like "standard template rendering"

      it "assigns a list of domains" do
        get :index
        expect(assigns(:domains)).to match_array [domain1, domain2]
      end
    end
    
  end
end