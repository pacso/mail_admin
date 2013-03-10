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
      
      it "fetches the users mailbox" do
        get :index
        expect(assigns(:my_account)).to eq mailbox
      end
    end
  end
  
  context "when signed out" do
    describe "GET #index" do
      it "requires you to sign in" do
        get :index
        expect(response).to require_sign_in
      end
    end
  end
  
  context "when signed in" do
    before(:each) do
      set_current_mailbox mailbox
    end
    
    context "as a standard user" do
      let(:mailbox) { create(:mailbox, domain: domain1) }
      it_behaves_like "standard template rendering"
      
      describe "GET #index" do
        it "does not assign a list of domains" do
          get :index
          expect(assigns(:domains)).to be_nil
        end
      end
    end

    context "as a domain admin" do
      let!(:mailbox) { create(:domain_admin_mailbox, domain: domain1) }
      let!(:mailbox1) { create(:mailbox, domain: domain1) }
      let!(:mailbox2) { create(:mailbox, domain: domain1) }
      let!(:other_mailbox) { create(:mailbox, domain: domain2) }
      it_behaves_like "standard template rendering"

      describe "GET #index" do
        it "fetches all accounts for the current_mailbox domain" do
          get :index
          expect(assigns(:mailboxes)).to match_array [mailbox, mailbox1, mailbox2]
        end
        # This test explicitly requires other_mailbox not to be included in @mailboxes
        # Redundant since previous test covers this requirement, but included for clarity
        it "does not include mailboxes from other domains" do 
          get :index
          expect(assigns(:mailboxes)).to_not include other_mailbox
        end
        it "does not assign a list of domains" do
          get :index
          expect(assigns(:domains)).to be_nil
        end
      end
    end

    context "as a site admin" do
      let(:mailbox) { create(:site_admin_mailbox, domain: domain1) }
      it_behaves_like "standard template rendering"

      describe "GET #index" do
        it "assigns a list of domains" do
          get :index
          expect(assigns(:domains)).to match_array [domain1, domain2]
        end
      end
    end
    
  end
end