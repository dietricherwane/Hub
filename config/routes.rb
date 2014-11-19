Hub::Application.routes.draw do
  #redirect("/users/sign_in")
  devise_scope :user do
    root :to => "home#home"
    get "users/sign_in/select_profile" => "users#select_sign_in_profile", as: :select_sign_in_profile
    get "users/sign_up/select_profile" => "users#select_sign_up_profile", as: :select_sign_up_profile
  end

  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions", :passwords => "users/passwords", :confirmations => "users/confirmations"}

  get "merchant/ecommerce" => "ecommerces#index", as: :merchant_ecommerce
  post "merchant/ecommerce/create" => "ecommerces#create", as: :merchant_create_ecommerce
  get "merchant/ecommerce/edit" => "ecommerces#edit", as: :merchant_edit_ecommerce
  post "merchant/ecommerce/update" => "ecommerces#update", as: :merchant_update_ecommerce
  get "merchant/ecommerce/update" => "ecommerces#edit"

  get "admin/ecommerces/waiting_qualification" => "ecommerces#waiting_qualification", as: :ecommerces_waiting_qualification
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
