Rails.application.routes.draw do

  namespace :admin do
    get 'review/show'
  end
  namespace :admin do
    get 'items/index'
    get 'items/show'
    get 'items/new'
  end
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

    get 'mypage', to: 'users#mypage', as: 'mypage'

    resources :items, only: [:new, :create, :index, :show] do
      resources :reviews, only: [:new, :create, :show, :edit, :update, :destroy] do
        resources :comments, only: [:create, :destroy]
      end
    end
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get :followings
        get :followers
      end
      resource :relationship, only: [:create, :destroy]
    end
  end

  # 管理者用リソース
  namespace :admin do
    root to: "homes#top"
    resources :items do
      resources :reviews, only: [:show, :destroy]
    end
    resources :users, only: [:index, :show, :destroy]
  end

end

