# frozen_string_literal: true

require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.credentials[:secret_key_base]

Rails.application.routes.draw do

  get 'application_status' => "status#application_status"
  # config/routes.rb
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :custom_report_templates
  get 'tags.json' => "application#tags"
  get 'geoname_summaries.json' => "application#geoname_summaries"

  resources :frame_types
  resources :reminders
  resources :stages
  get 'offline/work_form'

  get 'offline/offline'

  get 'offline/collections'

  get 'offline/collection'

  namespace :api do
    namespace :v1 do
      resources :collections, only: [] do
        resources :works, only: [:index, :show]
      end
    end
  end

  resources :messages do
    get 'new_reply' => 'messages#new'
  end
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :currencies
  resources :placeabilities
  resources :subsets
  resources :themes
  resources :sources
  resources :frame_damage_types
  resources :damage_types
  resources :conditions
  resources :media
  resources :techniques
  resources :object_categories
  resources :rkd_artists do
    patch 'copy' => 'rkd_artists#copy'
  end

  resources :works do
    resources :attachments
  end


  resources :involvements
  resources :collections do
    get 'manage' => 'collections#manage'

    resources :reminders, path: 'manage/reminders'
    resources :themes, path: 'manage/themes'
    resources :clusters
    resources :import_collections, path: 'manage/import_collections' do
      get 'preview' => 'import_collections#preview'
      patch 'delete_works' => 'import_collections#delete_works'
      patch 'import_works' => 'import_collections#import_works'
    end

    resources :owners
    resources :custom_reports, path: 'manage/custom_reports'

    resources :attachments
    resources :collections_stages
    resources :messages
    post 'refresh_works' => 'collections#refresh_works'
    resources :collections do
    end
    resources :batch_photo_uploads do
      post 'match_works' => 'batch_photo_uploads#match_works'
    end
    resources :artists do
      get 'combine_prepare' => 'artists#combine_prepare'
      patch 'combine' => 'artists#combine'
      get 'rkd_artists' => 'artists#rkd_artists'
      resources :artist_involvements
    end
    resources :rkd_artists do
      patch 'copy' => 'rkd_artists#copy'
    end

    get 'works/batch' => 'works_batch#index'
    get 'works/batch/edit' => 'works_batch#edit'
    get 'works/modified' => 'works#modified_index'
    post 'works/batch/edit' => 'works_batch#edit'
    patch 'works/batch' => 'works_batch#update'

    get 'mobile' => 'mobiles#show'
    patch 'mobile' => 'mobiles#update'

    resources :works do
      resources :attachments
      resources :appraisals
      resources :messages
      get 'location_history' => 'works#location_history'
      get 'edit_location' => 'works#edit_location'
      get 'edit_tags' => 'works#edit_tags'
      get 'edit_photos' => 'works#edit_photos'
    end

    get 'report' => 'collections#report'
  end
  resources :artists do
    get 'combine_prepare' => 'artists#combine_prepare'
    patch 'combine' => 'artists#combine'
    get 'rkd_artists' => 'artists#rkd_artists'
    resources :artist_involvements
  end
  post '/artists/clean' => 'artists#clean'


  resources :professional_activities

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "debug-offline" => 'application#debug_offline'
  get "heartbeat" => 'application#heartbeat'
  get "admin" => 'application#admin'
  get "sw" => 'application#service_worker'
  get "privacy" => "application#privacy"
  get "data-policy" => "application#data_policy"
  get "style-guide" => "application#style_guide"
  # You can have the root of your site routed with "root"
  root 'application#home'

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
