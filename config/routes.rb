# frozen_string_literal: true

Rails.application.routes.draw do
  root 'fields#index'

  resources :fields
end
