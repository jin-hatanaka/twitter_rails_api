# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :tweets, dependent: :destroy
  has_many :comments, dependent: :destroy
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
end
