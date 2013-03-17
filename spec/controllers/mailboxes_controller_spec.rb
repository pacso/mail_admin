require 'spec_helper'

shared_examples_for "standard MailboxesController template rendering" do
  describe "GET #new" do
    it "renders the new view" do
      get :new
      expect(response).to render_template :new
    end
  end
end

describe MailboxesController do
  let!(:domain) { create :domain }
  let!(:other_domain) { create :domain }
  let!(:mailbox) { create :mailbox, domain: domain }
  let!(:user_mailbox) { create :mailbox, domain: domain }
  let!(:domain_admin_mailbox) { create :domain_admin_mailbox, domain: domain }
  let!(:other_mailbox) { create :mailbox, domain: other_domain }
  
  context "when signed out" do
    describe "GET #new" do
      it "requires you to sign in" do
        get :new
        expect(response).to require_sign_in
      end
    end
  end
  
  context "when signed in" do
    before(:each) do
      set_current_mailbox current_mailbox
    end
    
    context "as a normal user" do
      let(:current_mailbox) { user_mailbox }
      
      describe "GET #new" do
        it "redirects to the root_url" do
          get :new
          expect(response).to redirect_to root_url
        end
      end
    end
    
    context "as a domain admin" do
      let(:current_mailbox) { domain_admin_mailbox }
      
      it_behaves_like "standard MailboxesController template rendering"
      
      describe "GET #new" do
        it "allows access for domain admins" do
          get :new
          expect(response).to render_template :new
        end
        it "assigns current_mailbox.domain to @domain" do
          get :new
          expect(assigns :domain).to eq current_mailbox.domain
        end
        it "builds a mailbox on the current_mailbox.domain" do
          get :new
          expect(assigns(:mailbox).domain).to eq current_mailbox.domain
        end
      end
      
      describe "POST #create" do
        context "with valid attibutes" do
          it "creates the new mailbox in the database" do
            expect{
              post :create, mailbox: attributes_for(:mailbox)
            }.to change(Mailbox, :count).by(1)
          end
          it "forces domain to be that of domain_admin" do
            post :create, mailbox: attributes_for(:mailbox, domain_id: other_domain)
            expect(assigns(:mailbox).domain).to eq current_mailbox.domain
          end
        end
        context "with invalid attributes" do
          it "does not save the new mailbox in the database" do
            expect{
              post :create, mailbox: attributes_for(:invalid_mailbox)
            }.to_not change(Mailbox, :count)
          end
          it "renders the new template" do
            post :create, mailbox: attributes_for(:invalid_mailbox)
            expect(response).to render_template :new
          end
        end
      end
      
      describe "GET #edit" do
        it "allows access to mailboxes within their domain" do
          get :edit, id: mailbox.id
          expect(response).to render_template :edit
        end
        it "denies access to mailboxes on other domains" do
          get :edit, id: other_mailbox.id
          expect(response).to redirect_to root_path
        end
      end
      
      describe "PUT #update" do
        context "with valid attributes" do
          it "redirects to the domain accounts index" do
            put :update, id: mailbox, mailbox: attributes_for(:mailbox)
            expect(response).to redirect_to tabbed_home_path(:domain_admin, :accounts)
          end
          
          it "changes @mailbox attributes" do
            put :update, id: mailbox, mailbox: attributes_for(:mailbox, delete_spam_threshold: 10)
            expect(mailbox.reload.delete_spam_threshold).to eq 10
          end
          
          context "for a mailbox on another domain" do
            it "does not change @mailboxes attributes" do
              put :update, id: other_mailbox, mailbox: attributes_for(:mailbox, delete_spam_threshold: 10)
              expect(other_mailbox.reload.delete_spam_threshold).to_not eq 10
            end
            
            it "redirects to the root_path" do
              put :update, id: other_mailbox, mailbox: attributes_for(:mailbox, delete_spam_threshold: 10)
              expect(response).to redirect_to root_path
            end
          end
        end
        context "with invalid attributes" do
          it "renders the edit template" do
            put :update, id: mailbox, mailbox: attributes_for(:invalid_mailbox)
            expect(response).to render_template :edit
          end
          
          it "does not change @mailboxes attributes" do
            put :update, id: mailbox, mailbox: attributes_for(:invalid_mailbox, delete_spam_threshold: 10)
            expect(mailbox.reload.delete_spam_threshold).to_not eq 10
          end
        end
      end
      
      describe "DELETE #destroy" do
        context "for a mailbox on the domain_admin's domain" do
          it "deletes the mailbox from the database" do
            expect{
              delete :destroy, id: mailbox
            }.to change(Mailbox, :count).by(-1)
          end
          it "redirects to the domain accounts index" do
            delete :destroy, id: mailbox
            expect(response).to redirect_to tabbed_home_path(:domain_admin, :accounts)
          end
        end
        context "for a mailbox on another domain" do
          it "deletes the mailbox from the database" do
            expect{
              delete :destroy, id: other_mailbox
            }.to_not change(Mailbox, :count)
          end
          it "redirects to the root_path" do
            delete :destroy, id: other_mailbox
            expect(response).to redirect_to root_path
          end
        end
      end
    end
  end
end
