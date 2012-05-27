ReadBeam::Application.routes.draw do  
  resources :sources

  devise_for :users, :path_names => { :sign_in => 'log-in',
                                      :sign_out => 'log-out',
                                      :sign_up => 'sign-up' }

  resources :users

  resources :edocs do
    get 'featured', :on => :collection
    get 'log'
    get 'print'
    get 'mail'
    get 'download'
    get 'toggle_mailing'
  end

  match 'calibre-hosting', :to => 'pages#calibre_hosting', :as => 'calibre_hosting'
  match 'download-ebook-ipad', :to => 'pages#download_ebook_ipad', :as => 'download_ebook_ipad'
  match 'download-ebook-kindle', :to => 'pages#download_ebook_kindle', :as => 'download_ebook_kindle'
  match 'calibre-ebook-conversion', :to => 'pages#calibre_ebook_conversion', :as => 'calibre_ebook_conversion'
  match 'kindle-blog-subscribe', :to => 'pages#kindle_blog_subscribe', :as => 'kindle_blog_subscribe'

  match ':recipe', :to => 'pages#source', :as => 'source_page'

  root :to => 'pages#index'
end