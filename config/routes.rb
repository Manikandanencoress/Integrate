Sumuru::Application.routes.draw do


  devise_for :admins,
             :path => :admin,
             :controllers => {
                 :registrations => 'admin/registrations',
                 :sessions => 'admin/foos'
             }
             
  resources :supports do 
    collection do 
      get 'documentation'
      get 'faqs'
      get 'tutorial'
      get 'contactus'
    end
 end    

  namespace :api do
    namespace :facebook_pay do
      resources :studios, :only => [] do
        match 'callback'
      end
    end
    resources 'wb_player_authorizations', :only => :index
    resource :cues, :only=> [] do
      get :callback
      get :share_counter
    end
  end

  namespace :admin do
    root :to => 'studios#index'

    resource :style_guide


    resources :studios do
      resource :branding, :controller => 'studios/branding'
      resources :users, :controller => 'studios/users'
      resources :admins, :controller => 'studios/admins'
      resources :invitations, :controller => 'studios/invitations'   
         
      resources :movie_metrics_reports, :controller=>'studios/movie_metrics_reports'      
      resources :sales_reports, :controller=>'studios/sales_reports'   
         
      resource :reports do
        resource :tax_report, :controller => 'studios/reports/tax', :only => [:show]
        resource :movies, :controller => 'studios/reports/movies', :only => [:show]
      end

      member do          
        get :studiodetail
        get :archive_studiodetail
      end
      
      resources :movies do

        get "promotions"
        get "preview"

        member do
          put :wysiwyg_update
        end        
        collection do
          get "countrycode"
        end
        resources :orders, :only => [:index]

        resource :skin, :only => [:show, :edit, :update]
        resources :coupons
        
        resources :streams

        resources :comments do
          delete :moderate, :on => :collection
        end

        resources :coupons do
          delete :moderate, :on => :collection
        end

        resource :report
      end

      resources :series, :only => [:index, :show, :update, :destroy, :edit] do
        get :search, :on => :collection
      end


    end

    resources :orders, :only => [:update]

    resources :invitations
    
    resources :sales_reports
    resources :movie_metrics_reports, :only => [:index]
    resources :info_studios, :only => [:index]
    resources :admin_reports, :only => [:index] do
      post :update_user_list , :on => :collection
      post :update_movie_list , :on => :collection
    end
    resources :user_detail_reports, :only => [:index] do
      post :update_user_detail , :on => :collection
    end
    
  end

  resources :studios, :only => [:show] do

    resources :movies, :only => [:index, :show] do
      get :paypal_return, :as => :member
      get :paypal_cancel, :as => :member
      get :update_paypal_button, :as => :member

      resource :paypal, :only => [:new, :create] do
        get :callback, :on => :collection
      end
      resources :orders, :only => [:new, :show] do
        match "/:flash_config", :to => "orders#flash_config", :constraints => lambda { |u| u.fullpath.match(/flash_config/) }
        post :cookie, :on => :collection
        collection do
          get "fb_popped_up"
        end
      end
      get :fan_pages, :on => :collection
      get :check_coupon, :on => :member

    end
    resources :series, :only => [:show]
  end

  resources :movies, :only => [] do

    resources :hotspots, :only => [:create, :index]
    resources :comments, :only => [:index, :show, :create]
  end

  resources :comments do
    member do
      get 'stack'
    end
  end

  match "admin/studioinfo" => "admin/studios#studioinfo", :method=>:get
  match "admin/countrycode" => "admin/studios#countrycode", :method=>:get
  match "admin/load_movie/:id" => "admin/studios#load_movie", :method=>:post
  match "admin/studiolist" => "admin/studios#studiolist", :method=>:get
  match "admin/archive_studio" => "admin/studios#archive_studio", :method=>:get
  
  #match "admin/studiodetail/:id" => "admin/studios#studiodetail", :method=>:get
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action


  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "admin/studios#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
