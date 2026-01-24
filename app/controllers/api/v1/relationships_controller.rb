# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < ApplicationController
      def create
        follow = current_api_v1_user.relationships.build(follower_id: params[:user_id])
        user = User.find(params[:user_id])

        if follow.save
          # 通知作成メソッドの呼び出し
          user.create_notification_follow!(current_api_v1_user)
          render json: follow, status: :created
        else
          render json: follow.errors, status: :unprocessable_entity
        end
      end

      def destroy
        follow = current_api_v1_user.relationships.find_by(follower_id: params[:user_id])
        return head :not_found unless follow

        follow.destroy
        head :no_content
      end
    end
  end
end
