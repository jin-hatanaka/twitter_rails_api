# frozen_string_literal: true

module Api
  module V1
    class ImagesController < ApplicationController
      def create
        # content なし、user_id だけで空の Tweet を作成
        tweet = current_api_v1_user.tweets.build(content: '')
        tweet.save!

        # 画像は複数想定
        params[:images]&.each do |image|
          tweet.images.attach(image)
        end

        render json: {
          tweet_id: tweet.id,
          # url_for は Rails のヘルパーで、ActiveStorage の画像を実際にアクセスできるURLに変換する
          images: tweet.images.map { |img| url_for(img) }
        }, status: :created
      end
    end
  end
end
