# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        bookmark_tweets = current_api_v1_user.bookmark_tweets
                                             .includes(images_attachments: :blob, user: { icon_image_attachment: :blob })
                                             .order('bookmarks.created_at DESC')

        render json: format_bookmark_tweets(bookmark_tweets)
      end

      def create
        bookmark = current_api_v1_user.bookmarks.build(tweet_id: params[:tweet_id])

        if bookmark.save
          render json: bookmark, status: :created
        else
          render json: bookmark.errors, status: :unprocessable_entity
        end
      end

      def destroy
        bookmark = current_api_v1_user.bookmarks.find_by(tweet_id: params[:id])
        return head :not_found unless bookmark

        bookmark.destroy
        head :no_content
      end

      private

      def format_bookmark_tweets(bookmark_tweets)
        bookmark_tweets.map do |tweet|
          {
            id: tweet.id,
            content: tweet.content,
            createdAt: tweet.created_at,
            images: tweet.image_urls(516, 280),
            user: tweet.user,
            iconImage: tweet.user.icon_image_url(40, 40),
            retweetCount: tweet.retweets.count,
            isRetweeted: tweet.retweets.exists?(user_id: current_api_v1_user),
            likeCount: tweet.likes.count,
            isLiked: tweet.likes.exists?(user_id: current_api_v1_user),
            isBookmarked: tweet.bookmarks.exists?(user_id: current_api_v1_user)
          }
        end
      end
    end
  end
end
