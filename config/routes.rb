Rails.application.routes.draw do
  root "static_pages#home"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :users, except: [:destroy, :create, :new] do
    resources :courses, only: :show
    resources :user_subjects
    resources :user_tasks
  end

  namespace :supervisors do
    root "dashboard#index"
    resources :users
    resources :courses do
      resources :course_subjects
      resources :subjects, only: :show
      resources :user_courses
    end
    resources :subjects
  end
end
