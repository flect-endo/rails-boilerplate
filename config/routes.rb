Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'
  resources :notes
  resources :checklists do
    collection do
      post 'upload'
      delete 'destroy_all'
    end
  end
  resources :salesforce, only: [:index] do
    collection do
      get 'credentials'
      post 'onload'
    end
  end

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  devise_scope :user do
    get '/auth/:provider/callback' => 'users/sessions#callback'
    post '/auth/:provider/callback' => 'users/sessions#callback'
    post '/canvasui' => 'users/sessions#auth_signed_request'
  end
  get '/signout' => 'users/sessions#destroy', as: :signout

  resources :users do
    resources :attendances, only: [:index] do
      collection do
        match 'clock_in', via: [:get, :post], as: 'clock_in'
        match 'clock_out', via: [:get, :post], as: 'clock_out'
        delete 'destroy'
      end
    end
    member do
      # チェック項目
      get 'checklists', action: :index_checklists
      get 'checklists/new', action: :new_checklists
      match 'checklists', to: 'users#create_checklists', via: [:post, :put, :patch]
      delete 'checklists/:datetime', action: :destroy_checklists, as: :destroy_checklists
    end
  end

  resource :authentication_token, only: [:update, :destroy]

  get 'map' => 'map#index'
  post 'map/upload_list'=> 'map#upload_list'
  post 'map/places' => 'map#places'

  if Rails.env.development?
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

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
end
