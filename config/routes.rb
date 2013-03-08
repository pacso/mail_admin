MailAdmin::Application.routes.draw do
  root to: 'pages#index'
  
  get 'sign_in' => 'sessions#new', as: :sign_in
  post 'sign_in' => 'sessions#create', as: :sign_in
  delete 'sign_out' => 'sessions#destroy', as: :sign_out
  
end
