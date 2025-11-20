# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def create
        if params[:tweet_id].present?
          # 画像付きツイート
          tweet = Tweet.find(params[:tweet_id]) # 画像アップロード時に作成した Tweet を取得
          tweet.update(content: params[:content])
        else
          # 画像なしツイート
          tweet = current_api_v1_user.tweets.build(content: params[:content])
          tweet.save!
        end

        if tweet.persisted?
          render json: {
            tweet_id: tweet.id,
            content: tweet.content,
            images: tweet.images.map { |img| url_for(img) },
            created_at: tweet.created_at
          }, status: :created
        else
          render json: tweet.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
