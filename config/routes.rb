require 'docs_subdomain'

Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  # Read more about routing: http://guides.rubyonrails.org/routing.html

  namespace :admin do
    root to: 'dashboard#index', as: :dashboard

    resources :locations, except: :show do
      resources :services, except: [:show, :index]
    end

    resources :organizations, except: :show

    get 'locations/:location_id/services/confirm_delete_service', to: 'services#confirm_delete_service', as: :confirm_delete_service
    get 'organizations/confirm_delete_organization', to: 'organizations#confirm_delete_organization', as: :confirm_delete_organization
    get 'locations/confirm_delete_location', to: 'locations#confirm_delete_location', as: :confirm_delete_location

    get 'locations/:location_id/services/:id', to: 'services#edit'
    get 'locations/:id', to: 'locations#edit'
    get 'organizations/:id', to: 'organizations#edit'
  end

  devise_for :admins, path: 'admin', controllers: { registrations: 'admin/registrations' }

  namespace :sfadmin do
    resources :organizations, only: [:index, :show, :update] do
      resources :locations do
        resources :addresses
        resources :contacts
        resources :faxes
        resources :mail_addresses
        resources :phones
        resources :services
      end
    end
    resources :import_jobs, except: [ :edit, :update ]
    root to: 'dashboard#index'
  end

  root to: 'sfadmin/dashboard#index'
end
