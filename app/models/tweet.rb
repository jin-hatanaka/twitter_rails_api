# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many_attached :images

  # 画像のURL変換メソッド
  def image_urls(width, height)
    images.map do |img|
      resize_image = img.variant(resize_to_fill: [width, height]).processed
      Rails.application.routes.url_helpers.url_for(resize_image)
    end
  end

  def create_notification!(current_user, action, comment_id: nil)
    # いいねされているか検索
    tmp = current_user.active_notifications.where(visited_id: user_id, tweet_id: id, action: 'like')
    # いいねされている場合は処理を終了
    return if tmp.present?

    notification = current_user.active_notifications.new(
      visited_id: user_id,
      tweet_id: id,
      comment_id:,
      action:,
      # 自分の投稿に対するいいね、コメントの場合は通知済みとする
      checked: current_user.id == user_id
    )
    notification.save if notification.valid?
  end
end
