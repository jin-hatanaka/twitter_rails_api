# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :tweets, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_one_attached :icon_image
  has_one_attached :header_image

  # フォローする側からのhas_many
  has_many :relationships, foreign_key: :following_id, dependent: :destroy,
                           inverse_of: :following
  # 一覧画面で使用する（あるユーザーがフォローしている人全員をとってくる）
  has_many :followings, through: :relationships, source: :follower

  # フォローされる側からのhas_many
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy,
                                      inverse_of: :follower
  # 一覧画面で使用する（あるユーザーのフォロワー全員をとってくる）
  has_many :followers, through: :reverse_of_relationships, source: :following

  # 通知を送る側からのhas_many
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy,
                                  inverse_of: :visitor

  # 通知を受け取る側からのhas_mamy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy,
                                   inverse_of: :visited

  # ユーザーがブックマークしたツイートをとってくる
  has_many :bookmark_tweets, through: :bookmarks, source: :tweet

  # アイコン画像のURL変換メソッド
  def icon_image_url(width, height)
    resize_image = icon_image.variant(resize_to_fill: [width, height]).processed
    Rails.application.routes.url_helpers.url_for(resize_image)
  end

  # ヘッダー画像のURL変換メソッド
  def header_image_url
    return unless header_image.attached?

    resize_image = header_image.variant(resize_to_fill: [600, 200]).processed
    Rails.application.routes.url_helpers.url_for(resize_image)
  end

  def create_notification_follow!(current_user)
    # フォローされている場合は処理を終了
    return if current_user.active_notifications.exists?(visited_id: id, action: :follow)

    notification = current_user.active_notifications.new(
      visited_id: id,
      action: :follow
    )
    notification.save if notification.valid?
  end
end
