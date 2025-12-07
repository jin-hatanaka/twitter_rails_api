# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!

      def me
        user = current_api_v1_user
        render json: {
          id: user.id,
          name: user.name,
          iconImage: user.icon_image_url
        }
      end
    end
  end
end
