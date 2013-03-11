MailAdmin::Application.routes.draw do
  root to: 'pages#index'
  
  get 'sign_in' => 'sessions#new', as: :sign_in
  post 'sign_in' => 'sessions#create', as: :sign_in
  delete 'sign_out' => 'sessions#destroy', as: :sign_out
  
  get 'change_password' => 'passwords#new', as: :change_password
  put 'change_password' => 'passwords#update', as: :change_password

  resource :my_account
  resource :domain do
    resources :mailboxes
  end
end
