Rails.application.routes.draw do
  root "check#index"

  resources :check, only: [:index, :show] do
    member do
      post :evaluate
    end
  end
end
