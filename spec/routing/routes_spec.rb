require 'spec_helper'

describe "Routes" do

  it "get / to pages#index" do
    expect(get: '/').to route_to(
      controller: "pages",
      action: "index"
    )
  end
  
  it "get /sign_in to sessions#new" do
    expect(get: '/sign_in').to route_to(
      controller: 'sessions',
      action: 'new'
    )
  end
  
  it "post /sign_in to sessions#create" do
    expect(post: '/sign_in').to route_to(
      controller: 'sessions',
      action: 'create'
    )
  end
  
  it "delete /sign_out to sessions#destroy" do
    expect(delete: '/sign_out').to route_to(
      controller: 'sessions',
      action: 'destroy'
    )
  end
  
  it "get /change_password to passwords#new" do
    expect(get: '/change_password').to route_to(
      controller: 'passwords',
      action: 'new'
    )
  end
  
  it "put /change_password to passwords#update" do
    expect(put: '/change_password').to route_to(
      controller: 'passwords',
      action: 'update'
    )
  end
end