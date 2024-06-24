# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @articles = Article.all.order(updated_at: :desc).limit(10)
    @categories = Category.all.limit(8)
  end
end
