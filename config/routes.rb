Rails.application.routes.draw do

  # 顧客用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }


  # 顧客用リソース
  root to: "public/homes#top"
    get "about", to: "public/homes#about", as: "homes_about"

end

