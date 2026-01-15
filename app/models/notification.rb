# frozen_string_literal: true

class Notification < ApplicationRecord
  # デフォルトの並び順を作成日時の降順にする(新しいものから取得)
  default_scope -> { order(created_at: :desc) }
  # optional: true でカラム内のnilを許容する
  belongs_to :tweet, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
end
