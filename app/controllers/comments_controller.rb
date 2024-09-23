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

    comment_like_dislike = CommentLikeDislike.find_or_initialize_by(comment_id: params[:id], user: current_user)

    if comment_like_dislike.new_record?
      comment_like_dislike.save!
      Comment.find(params[:id]).increment!(:like)
      redirect_to(article_path(@article), notice: "Like registrado com sucesso")
    else
      message = "Não foi possível registrar o dislike"
      message = "Você já registrou um like ou dislike para este comentário" if comment_like_dislike.persisted?
      redirect_to(article_path(@article), alert: message)
    end
  end

  def dislike
    @article = Article.friendly.find(params[:article_id])

    comment_like_dislike = CommentLikeDislike.find_or_initialize_by(comment_id: params[:id], user: current_user)

    if comment_like_dislike.new_record?
      comment_like_dislike.save!
      Comment.find(params[:id]).increment!(:dislike)
      redirect_to(article_path(@article), notice: "Dislike registrado com sucesso")
    else
      message = "Não foi possível registrar o dislike"
      message = "Você já registrou um like ou dislike para este comentário" if comment_like_dislike.persisted?
      redirect_to(article_path(@article), alert: message)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
