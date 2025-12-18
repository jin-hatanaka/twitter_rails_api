# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!

      def me
        user = current_api_v1_user
        render json: {
          id: user.id,
          name: user.name,
          iconImage: user.icon_image_url(40, 40)
        }
      end

      def show
        user = User
               .includes(icon_image_attachment: :blob, header_image_attachment: :blob)
               .find(params[:id])
        tweets = user.tweets
                     .includes(images_attachments: :blob)
                     .order(created_at: 'DESC')
        render json: {
          user: {
            id: user.id,
            name: user.name,
            birthDate: user.birth_date,
            selfIntroduction: user.self_introduction,
            place: user.place,
            website: user.website,
            followCount: user.followings.count,
            followerCount: user.followers.count,
            iconImage: user.icon_image_url(132, 132),
            headerImage: user.header_image_url
          },
          tweets: format_json(tweets),
          tweetCount: tweets.count
        }
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: {
            id: user.id,
            name: user.name,
            iconImage: user.icon_image_url(40, 40)
          }
        else
          render json: user.errors, status: :unprocessable_entity
        end
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
            iconImage: tweet.user.icon_image_url(40, 40)
          }
        end
      end

      def user_params
        params.require(:user).permit(:name, :self_introduction, :place, :website, :birth_date, :header_image, :icon_image)
      end
    end
  end
end
