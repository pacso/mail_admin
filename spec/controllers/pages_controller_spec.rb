require 'spec_helper'

describe PagesController do
  
  describe "GET #index" do
    context "when not logged in" do
      it "redirects to the sign_in page" do
        get :index
        response.should redirect_to sign_in_path
      end
    end
    describe "when logged in" do
      context "as a site_admin" do
        let!(:domain1) { create :domain }
        let!(:domain2) { create :domain }
        let(:mailbox) { create :site_admin_mailbox, domain: domain1 }
        before(:each) do
          session[:mailbox_id] = mailbox.id
        end
        
        it "assigns a list of domains" do
          get :index
          assigns(:domains).should eq [domain1, domain2]
        end
      end
    end
  end
end
