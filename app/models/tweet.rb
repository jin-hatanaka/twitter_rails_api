# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  # 画像のURL変換メソッド
  def image_urls(width, height)
    # images.map { |img| Rails.application.routes.url_helpers.rails_blob_url(img, only_path: false) }
    images.map do |img|
      resize_image = img.variant(resize_to_fill: [width, height]).processed
      # resize_image = img.variant(gravity: :center, resize:"500x270^", crop:"500x270+0+0").processed
      Rails.application.routes.url_helpers.url_for(resize_image)
    end
  end
end
