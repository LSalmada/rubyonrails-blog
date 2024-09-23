# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :set_footer_data

  private

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referer if resource_or_scope == :user
  end

  def set_footer_data
    return if params[:controller].split("/").first == "administrate"

    @footer_categories_1 = Category.all.order(created_at: :asc).limit(4)
    @footer_categories_2 = Category.all.order(created_at: :desc).limit(4)

    @footer_articles = Article.all.limit(4)
  end
end
