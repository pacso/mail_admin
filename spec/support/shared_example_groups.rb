module SharedExampleGroups
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
end