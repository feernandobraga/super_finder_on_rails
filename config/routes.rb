Rails.application.routes.draw do
  get 'documents/home'
  get 'documents/result'
  post 'documents/home', to: "documents#fetch"

  # get 'documents/fetch', to: "documents#fetch"

end
