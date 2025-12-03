# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def index
        # limitは1ページあたりの最大表示件数
        # offsetは取得を開始するデータの一番最初の位置（スキップする件数）
        limit = params[:limit].to_i
        # おすすめタブの開始位置
        recommended_offset = params[:recommended_offset].to_i
        # フォロー中タブの開始位置
        following_offset = params[:following_offset].to_i

        # おすすめのツイート
        tweets = Tweet
                 .order(created_at: 'DESC')
                 .includes(images_attachments: :blob, user: { icon_image_attachment: :blob })
                 .limit(limit)
                 .offset(recommended_offset)

        # フォロー中のツイート
        all_following_tweets = Tweet.where(user: current_api_v1_user.followings)

        following_tweets = all_following_tweets
                           .order(created_at: 'DESC')
                           .includes(images_attachments: :blob, user: { icon_image_attachment: :blob })
                           .limit(limit)
                           .offset(following_offset)

        render json: {
          tweets: {
            data: format_json(tweets),
            count: Tweet.count
          },
          followingTweets: {
            data: format_json(following_tweets),
            count: all_following_tweets.count
          }
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

      private

      def format_json(tweets)
        tweets.map do |tweet|
          {
            id: tweet.id,
            content: tweet.content,
            createdAt: tweet.created_at,
            images: tweet.image_urls,
            user: tweet.user,
            iconImage: tweet.user.icon_image_url
          }
        end
      end
    end
  end
end
