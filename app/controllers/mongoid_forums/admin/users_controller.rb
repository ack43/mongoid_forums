require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class UsersController < BaseController

      before_action :set_user, only: [:add_admin, :remove_admin]

      def index
        @admins = User.mongoid_forums_admins
        @non_admins = User.non_mongoid_forums_admins
      end

      def add_admin
        @user.roles << "mongoid_forums_admin"
        @user.save
        redirect_to admin_users_path
      end

      def remove_admin
        @user.roles.delete "mongoid_forums_admin"
        @user.save
        redirect_to admin_users_path
      end

      private

      def set_user
        @user = User.find(params[:user][:id])
      end

    end
  end
end
