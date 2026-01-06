# frozen_string_literal: true

module Api
  module V1
    class RetweetsController < ApplicationController
      def create
        retweet = current_api_v1_user.retweets.build(tweet_id: params[:tweet_id])

        if retweet.save
          render josn: retweet, status: :created
        else
          render json: retweet.error, status: :unprocessable_entity
        end
      end

      def destroy
        retweet = current_api_v1_user.retweets.find_by(tweet_id: params[:tweet_id])
        return head :not_found unless retweet
        return head :forbidden unless retweet.user.id == current_api_v1_user.id

        retweet.destroy
        head :no_content
      end
    end
  end
end
