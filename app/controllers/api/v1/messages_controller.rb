# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      def index
        group = Group.find(params[:group_id])
        messages = group.messages
        another_user = group.users.where.not(id: current_api_v1_user.id).first

        render json: {
          messages: format_messages(messages),
          anotherUser: {
            name: another_user.name,
            iconImage: another_user.icon_image_url(40, 40)
          },
          groupId: group.id
        }
      end

      def create
        group = Group.find(params[:group_id])
        message = group.messages.build(user_id: current_api_v1_user.id, content: params[:content])

        if message.save
          render json: message, status: :created
        else
          render json: message.errors, status: :unprocessable_entity
        end
      end

      private

      def format_messages(messages)
        messages.map do |message|
          {
            id: message.id,
            userId: message.user.id,
            content: message.content
          }
        end
      end
    end
  end
end
