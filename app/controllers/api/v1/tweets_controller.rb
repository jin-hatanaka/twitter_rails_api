# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def create
        tweet = current_api_v1_user.tweets.build(content: params[:content])

        if tweet.save
          render json: {
            tweet_id: tweet.id,
            content: tweet.content,
            created_at: tweet.created_at
          }, status: :created
        else
          render json: tweet.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
