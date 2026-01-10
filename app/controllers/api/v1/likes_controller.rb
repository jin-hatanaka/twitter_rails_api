# frozen_string_literal: true

module Api
  module V1
    class LikesController < ApplicationController
      def create
        like = current_api_v1_user.likes.build(tweet_id: params[:tweet_id])

        if like.save
          render josn: like, status: :created
        else
          render json: like.error, status: :unprocessable_entity
        end
      end

      def destroy
        like = current_api_v1_user.likes.find_by(tweet_id: params[:tweet_id])
        return head :not_found unless like
        return head :forbidden unless like.user.id == current_api_v1_user.id

        like.destroy
        head :no_content
      end
    end
  end
end
