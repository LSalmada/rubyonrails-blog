# frozen_string_literal: true

class ArticlesController < ApplicationController
  def show
    @article = Article.includes(:category, :author, comments: :user ).friendly.find(params[:id])
    @other_articles = Article.all.sample(3)
    @comments = comments_sorted
  end

  private

  def comments_sorted
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    puts params[:sort_by]
    return @article.comments.order(created_at: :desc) if params[:sort_by] == "most_recent"

    @article.comments.order(created_at: :asc)
  end
end
