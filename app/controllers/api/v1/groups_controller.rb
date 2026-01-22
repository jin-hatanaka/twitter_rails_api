# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      def index
        my_group_ids = current_api_v1_user.entries.pluck(:group_id)
        another_entries = Entry.where(group_id: my_group_ids)
                               .where.not(user_id: current_api_v1_user.id)
                               .includes(user: { icon_image_attachment: :blob })

        render json: format_another_entries(another_entries)
      end

      # ログインユーザーとDMする相手ユーザーのgroupが存在するか調べる。なければ作成する。
      def create
        user = User.find(params[:user_id])
        my_group_ids = current_api_v1_user.entries.pluck(:group_id)

        existing_group = user.entries.where(group_id: my_group_ids)
        return head :ok if existing_group.exists?

        group = Group.new

        ApplicationRecord.transaction do
          group.save!
          group.entries.create!(user_id: current_api_v1_user.id)
          group.entries.create!(user_id: user.id)
        end

        render json: group, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def format_another_entries(another_entries)
        another_entries.map do |entry|
          {
            id: entry.id,
            userName: entry.user.name,
            iconImage: entry.user.icon_image_url(40, 40),
            groupId: entry.group.id
          }
        end
      end
    end
  end
end
