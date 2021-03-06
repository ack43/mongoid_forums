require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class Admin::ForumsController < BaseController
      before_action :set_forum, only: [:add_group, :remove_group]

      def index
        @forums = Forum.all
      end

      def new
        @forum = Forum.new
      end

      def create
        @forum = Forum.new(forum_params)
        if @forum.save
          flash[:notice] = t("mongoid_forums.admin.forum.created")
          redirect_to [:admin, @forum]
        else
          flash.now.alert = t("mongoid_forums.admin.forum.not_created")
          render :action => "new"
        end
      end

      def show
        @forum = Forum.find(params[:id])
        @groups = Group.all.where(moderator: true).select{ |group| !@forum.moderator_groups.include?(group) }
      end

      def edit
        @forum = Forum.find(params[:id])
      end

      def update
        @forum = Forum.find(params[:id])
        if @forum.update(forum_params)
          flash[:notice] = t("mongoid_forums.admin.forum.updated")
          redirect_to @forum
        else
          flash.now.alert = t("mongoid_forums.admin.forum.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        @forum = Forum.find(params[:id])
        @forum.destroy
        flash[:notice] = t("mongoid_forums.admin.forum.deleted")
        redirect_to admin_forums_path
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_group
        group = Group.find(params[:group][:id])
        @forum.moderator_groups << group
        @forum.save

        redirect_to admin_forum_path(@forum)
      end

      def remove_group
        group = Group.find(params[:group][:id])
        @forum.moderator_groups.delete(group)
        @forum.save

        redirect_to admin_forum_path(@forum)
      end
      #########################################################

      private

      def forum_params
        params.require(:forum).permit(:name, :category)
      end

      def set_forum
        @forum = Forum.find(params[:forum_id])
      end
    end
  end
end
