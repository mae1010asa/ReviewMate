Rails.application.routes.draw do



  namespace :public do
    get 'items/index'
    get 'items/show'
  end
  namespace :public do
    get 'reviews/new'
    get 'reviews/index'
    get 'reviews/show'
    get 'reviews/edit'
  end
  # 顧客用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }


  # 顧客用リソース
  root to: "public/homes#top"
    get "about", to: "public/homes#about", as: "homes_about"
  scope module: :public do

    resources :items, only: [:index, :show] do
      resources :reviews, only: [:new, :create, :destroy]
    end
    
  end

end

