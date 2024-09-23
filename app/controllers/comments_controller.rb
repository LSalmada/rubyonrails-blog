# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @article = Article.friendly.find(params[:article_id])
    comment = @article.comments.new(comment_params)

    if comment.save
      redirect_to(article_path(@article), notice: "Comentário criado com sucesso")
    else
      redirect_to(
        article_path(@article),
        alert: "Erro ao criar comentário - #{comment.errors.full_messages.join(", ")}",
      )
    end
  end

  def like
    @article = Article.friendly.find(params[:article_id])

    if Comment.find(params[:id]).increment!(:like)
      redirect_to(article_path(@article), notice: "Like registrado com sucesso")
    else
      redirect_to(article_path(@article), alert: "Não foi possível registrar o like")
    end
  end

  def dislike
    @article = Article.friendly.find(params[:article_id])

    if Comment.find(params[:id]).increment!(:dislike)
      redirect_to(article_path(@article), notice: "Dislike registrado com sucesso")
    else
      redirect_to(article_path(@article), alert: "Não foi possível registrar o dislike")
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
