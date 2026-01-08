# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :images

  # 画像のURL変換メソッド
  def image_urls(width, height)
    images.map do |img|
      resize_image = img.variant(resize_to_fill: [width, height]).processed
      Rails.application.routes.url_helpers.url_for(resize_image)
    end
  end
end
