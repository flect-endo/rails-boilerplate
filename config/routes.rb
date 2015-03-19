Rails.application.routes.draw do
  get 'pictures/index'

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

  resources :pictures, only: [:index] do
    collection do
      post 'upload'
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
        delete ':date', action: 'destroy', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
        match 'time_entries/start', to: 'time_entries#start', via: [:get, :post]
        match 'time_entries/finish', to: 'time_entries#finish', via: [:get, :post]
      end
    end
    resources :user_checklists, only: [:index, :new] do
      collection do
        match '', action: 'create', via: [:post, :put, :patch], as: 'register'
        delete ':datetime', action: 'destroy'
      end
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
