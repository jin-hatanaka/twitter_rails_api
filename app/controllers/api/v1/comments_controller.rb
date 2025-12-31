# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      def index
        tweet = Tweet.find(params[:tweet_id])
        comments = tweet.comments
                        .includes(user: { icon_image_attachment: :blob })
                        .order(created_at: 'DESC')

        render json: {
          comments: format_comments(comments)
        }
      end

      def create
        comment = current_api_v1_user.comments.build(
          tweet_id: params[:tweet_id],
          content: params[:content]
        )

        if comment.save
          render json: comment, status: :created
        else
          render json: comment.error, status: :unprocessable_entity
        end
      end

      def destroy
        comment = Comment.find_by(id: params[:id])
        return head :not_found unless comment
        return head :forbidden unless comment.user.id == current_api_v1_user.id

        comment.destroy
        head :no_content
      end

      private

      def format_comments(comments)
        comments.map do |comment|
          {
            id: comment.id,
            content: comment.content,
            createdAt: comment.created_at,
            user: comment.user,
            iconImage: comment.user.icon_image_url(40, 40)
          }
        end
      end
    end
  end
end
