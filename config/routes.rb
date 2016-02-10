Hub::Application.routes.draw do
  #redirect("/users/sign_in")
  devise_scope :user do
    root :to => "home#home"
    get "users/sign_in/select_profile" => "users#select_sign_in_profile", as: :select_sign_in_profile
    get "users/sign_up/select_profile" => "users#select_sign_up_profile", as: :select_sign_up_profile
    get "users/pos_account" => "users/registrations#new_pos_account", as: :new_pos_account
    post "users/pos_account/create" => "users/registrations#create_pos_account", as: :create_pos_account
    patch "users/pos_account/create" => "users/registrations#create_pos_account"
    get "users/pos_account/create" => "users/registrations#new_pos_account"
    get "/merchant_pos_account_list" => "users/registrations#list_merchant_pos_account", as: :list_merchant_pos_account
    get "/private_pos_account/:certified_agent_id" => "users/registrations#new_private_pos_account", as: :new_private_pos_account
    post "/private_pos_account/create" => "users/registrations#create_private_pos_account", as: :create_private_pos_account
    patch "/private_pos_account/create" => "users/registrations#create_private_pos_account"
    get "/private_pos_account/list/:certified_agent_id" => "users/registrations#list_private_pos_account", as: :list_private_pos_account
    get "/api/wari/create_private_pos" => "users/registrations#api_create_wari_private_pos"
  end

  get 'contacts' => 'home#contact', as: :contact

  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions", :passwords => "users/passwords", :confirmations => "users/confirmations"}

  get "pos" => "posm#index", as: :posm_index
  get "pos/transactions" => "posm#transactions_log", as: :posm_transactions
  get "pos/cashout" => "posm#cashout", as: :cashout
  post "pos/cashout/proceed" => "posm#proceed_cashout", as: :posm_proceed_cashout

  get "merchant/ecommerce" => "ecommerces#index", as: :merchant_ecommerce
  post "merchant/ecommerce/create" => "ecommerces#create", as: :merchant_create_ecommerce
  get "merchant/ecommerce/edit" => "ecommerces#edit", as: :merchant_edit_ecommerce
  post "merchant/ecommerce/update" => "ecommerces#update", as: :merchant_update_ecommerce
  get "merchant/ecommerce/update" => "ecommerces#edit"
  get "merchant/ecommerce/enable/:ecommerce_id" => "ecommerces#enable", as: :merchant_enable_ecommerce
  get "merchant/ecommerce/disable/:ecommerce_id" => "ecommerces#disable", as: :merchant_disable_ecommerce
  get "merchant/ecommerce/wallets_per_country" => "ecommerces#merchant_list_wallets_per_country", as: :merchant_wallets_per_country
  get "merchant/ecommerce/successful_transactions_per_wallet/:authentication_token" => "ecommerces#merchant_successful_transactions_per_wallet", as: :merchant_successful_transactions_per_wallet
  get "merchant/ecommerce/failed_transactions_per_wallet/:authentication_token" => "ecommerces#merchant_failed_transactions_per_wallet", as: :merchant_failed_transactions_per_wallet

  get "admin/ecommerces/waiting_qualification" => "ecommerces#waiting_qualification", as: :ecommerces_waiting_qualification
  get "admin/ecommerces/qualified" => "ecommerces#qualified", as: :qualified_ecommerces
  get "admin/ecommerces/disabled" => "ecommerces#disabled", as: :disabled_ecommerces
  get "admin/ecommerce/wallets/available/:ecommerce_id" => "ecommerces#available_wallets", as: :ecommerce_available_wallets
  get "admin/ecommerce/wallet/enable/:available_wallet_id" => "ecommerces#enable_wallet", as: :enable_wallet
  get "admin/ecommerce/wallet/disable/:available_wallet_id" => "ecommerces#disable_wallet", as: :disable_wallet
  get "admin/ecommerce/qualify/:ecommerce_id" => "ecommerces#qualify", as: :qualify_ecommerce
  get "admin/ecommerce/enable/:ecommerce_id" => "ecommerces#enable", as: :enable_ecommerce
  get "admin/ecommerce/disable/:ecommerce_id" => "ecommerces#disable", as: :disable_ecommerce
  get 'admin/transactions/ecommerces' => 'ecommerces#transactions_list_ecommerces', as: :transactions_list_ecommerces
  get 'admin/transactions/countries/wallets/:ecommerce_token' =>  'ecommerces#admin_list_wallets_per_country', as: :admin_list_wallets_per_country
  get "admin/ecommerce/successful_transactions_per_wallet/:authentication_token/:ecommerce_token" => "ecommerces#admin_successful_transactions_per_wallet", as: :admin_successful_transactions_per_wallet
  get "admin/ecommerce/failed_transactions_per_wallet/:authentication_token/:ecommerce_token" => "ecommerces#admin_failed_transactions_per_wallet", as: :admin_failed_transactions_per_wallet

  get "ecommerce/get_logo/:token" => "ecommerces#get_logo"

  get "/api/367419f5968800cd/paymoney_wallet/store_log" => "paymoney_wallet_logs#store_transaction_log"

  get "pos/has_rib/:certified_agent_id" => "users#has_rib"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  get '*rogue_url', :to => 'errors#routing'
  post '*rogue_url', :to => 'errors#routing'
end
