# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
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
    end
  end
end
