require 'spec_helper'

describe MailboxesController do
  let!(:domain) { create :domain }
  let!(:mailbox) { create :mailbox, domain: domain }
  let!(:domain_admin_mailbox) { create :domain_admin_mailbox, domain: domain }
  let!(:other_mailbox) { create :mailbox }
  
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
      set_current_mailbox current_mailbox
    end
    
    context "as a domain admin" do
      let(:current_mailbox) { domain_admin_mailbox }
      
      it_behaves_like "standard template rendering"
    end
  end
  
end
