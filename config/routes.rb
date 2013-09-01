Blog::Application.routes.draw do

  root :to =>'home#index', :format => false

  # Admin/Controller
  %w{ articles feedbacks categories tags users profiles profile }.each do |i|
    match "/admin/#{i}", :to => "admin/#{i}#index", :format => false
    match "/admin/#{i}(/:action(/:id))", :to => "admin/#{i}", :action => nil, :id => nil, :format => false
  end

  # Admin/Accounts/Controller
  match "/admin" => "accounts#login"
  %w{ accounts }.each do |i|
    match "#{i}(/:action)", :to => i, :format => false
  end


  # Blog/Controller
  %w{ articles feedbacks profile coauthor}.each do |i|
    match "/blog/#{i}", :to => "blog/#{i}#index", :format => false
    match "/blog/#{i}(/:action(/:id))", :to => "blog/#{i}", :action => nil, :id => nil, :format => false
  end

  # Blog/Sessions/Controller
  %w{ sessions }.each do |i| 
    match "#{i}(/:action)", :to => i, :format => false
    match "#{i}(/:action(/:id))", :to => i, :action => nil, :id => nil, :format => false
  end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
