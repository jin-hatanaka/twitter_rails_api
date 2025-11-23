# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many_attached :images
end
