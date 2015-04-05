require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class CategoriesController < BaseController
      before_action :set_category, only: [:add_group, :remove_group]

      def index
        @forums = Forum.asc(:position)
        @categories = Category.asc(:position)
      end

      def show
        @category = Category.find(params[:id])
        @groups = Group.  all.where(moderator: true).select{ |group| !@category.moderator_groups.include?(group) }
      end

      def new
        @category = Category.new
      end

      def create
        if @category = Category.create(category_params)
          flash[:notice] = "Category created successfully"
          redirect_to admin_categories_path
        else
          flash.now.alert = "Category could not be created"
          render :action => "new"
        end
      end

      def edit
        @category = Category.find(params[:id])
      end

      def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
          flash[:notice] = "Category updated successfully"
          redirect_to admin_categories_path
        else
          flash.now.alert = "Category could not be updated"
          render :action => "edit"
        end
      end

      def destroy
        @category = Category.find(params[:id])
        if @category.destroy
          flash[:notice] = "Category destroyed successfully"
          redirect_to admin_categories_path
        else
          flash.now.alert = "Category could not be destroyed"
          render :action => "index"
        end
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_group
        group = Group.find(params[:group][:id])
        @category.moderator_groups << group
        @category.save

        redirect_to admin_category_path(@category)
      end

      def remove_group
        group = Group.find(params[:group][:id])
        @category.moderator_groups.delete(group)
        @category.save

        redirect_to admin_category_path(@category)
      end
      #########################################################

      private

      def category_params
        params.require(:category).permit(:name, :position)
      end

      def set_category
        @category = Category.find(params[:category_id])
      end
    end
  end
end
