require 'spec_helper'

describe PasswordsController do
  
  context "when signed in" do
    let(:mailbox) { create(:mailbox) }
    let(:old_password) { mailbox.password }
    let(:new_password) { 'newpass123' }
    before { set_current_mailbox(mailbox) }
    
    describe "GET #new" do
      it "assigns current_mailbox to @mailbox" do
        get :new
        expect(assigns(:mailbox)).to eq mailbox
      end
      it "renders the new template" do
        expect(get :new).to render_template :new
      end
    end
    
    
    describe "PUT #update" do
      context "using valid attributes" do
        it "redirects to the root_path" do
          # Mailbox.any_instance.should_receive(:update_attributes).with({password: new_password, password_confirmation: new_password})
          put :update, mailbox: { old_password: old_password, password: new_password, password_confirmation: new_password}
          expect(response).to redirect_to root_path          
        end
        it "assigns modified current_mailbox to @my_account" do
          put :update, mailbox: { old_password: old_password, password: new_password, password_confirmation: new_password}
          expect(assigns(:mailbox).password_digest).to_not eq mailbox.password_digest
        end
      end
      context "using invalid attributes" do
        it "renders the new template" do
          expect(put :update, mailbox: { old_password: new_password, password: new_password, password_confirmation: new_password}).to render_template :new
        end
        it "assigns current_mailbox to @mailbox" do
          put :update, mailbox: { old_password: new_password, password: new_password, password_confirmation: new_password}
          expect(assigns(:mailbox)).to eq mailbox
        end
      end
    end
  end
  
  
  context "when not signed in" do
    describe "GET #new" do
      it "requires you to sign in" do
        get :new
        expect(response).to require_sign_in
      end
    end

    describe "PUT #update" do
      it "requires you to sign in" do
        put :update
        expect(response).to require_sign_in
      end
    end
  end
end
