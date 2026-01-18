# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        notifications = current_api_v1_user.passive_notifications # ログインユーザーが受け取る側の通知データを取得
                                           .where.not(visitor_id: current_api_v1_user.id) # 自分の投稿に対する通知は表示しない
                                           .includes(:tweet, :comment, visitor: { icon_image_attachment: :blob })

        render json: format_notifications(notifications)

        # 未確認の通知レコードだけ取り出したあと、「未確認→確認済」になるように更新
        notifications.where(checked: false).each do |notification|
          notification.update(checked: true)
        end
      end

      private

      def format_notifications(notifications)
        notifications.map do |notification|
          {
            id: notification.id,
            action: notification.action,
            userName: notification.visitor.name,
            iconImage: notification.visitor.icon_image_url(32, 32),
            postContent: notification.tweet&.content,
            comment: notification.comment&.content
          }
        end
      end
    end
  end
end
