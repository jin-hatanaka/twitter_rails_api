# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def index
        # limitは1ページあたりの最大表示件数
        # offsetは取得を開始するデータの一番最初の位置（スキップする件数）
        limit = params[:limit].to_i
        offset = params[:offset].to_i

        tweets = Tweet
                 .order(created_at: 'DESC')
                 .includes(images_attachments: :blob, user: { icon_image_attachment: :blob })
                 .limit(limit)
                 .offset(offset)

        render json: {
          tweets: format_json(tweets),
          count: Tweet.count
        }
      end

      def show
        tweet = Tweet.find(params[:id])
        render json: {
          id: tweet.id,
          content: tweet.content,
          createdAt: tweet.created_at,
          images: tweet.image_urls(564, 300),
          user: tweet.user,
          iconImage: tweet.user.icon_image_url(40, 40)
        }
      end

      def create
        tweet = current_api_v1_user.tweets.build(content: params[:content])

        if tweet.save
          render json: {
            id: tweet.id,
            content: tweet.content,
            createdAt: tweet.created_at
          }, status: :created
        else
          render json: tweet.errors, status: :unprocessable_entity
        end
      end

      def destroy
        tweet = Tweet.find_by(id: params[:id])
        # head でステータスコードのみ返す
        return head :not_found unless tweet
        return head :forbidden unless tweet.user.id == current_api_v1_user.id

        tweet.destroy
        head :no_content
      end

      private

      def format_json(tweets)
        tweets.map do |tweet|
          {
            id: tweet.id,
            content: tweet.content,
            createdAt: tweet.created_at,
            images: tweet.image_urls(516, 280),
            user: tweet.user,
            iconImage: tweet.user.icon_image_url(40, 40),
            retweetCount: tweet.retweets.count,
            isRetweeted: tweet.retweets.exists?(user_id: current_api_v1_user)
          }
        end
      end
    end
  end
end
