# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      def sign_up_params
        Rails.logger.debug(params.inspect)
        params.require(:registration).permit(:name, :email, :birth_date, :password, :password_confirmation)
      end
    end
  end
end
