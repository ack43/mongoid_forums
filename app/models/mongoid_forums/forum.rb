module MongoidForums
  class Forum
    include Mongoid::Document
    include ::Mongoid::Timestamps
    include MongoidForums::Concerns::Viewable

    include Enableable
    # include Seoable
    include SortField

    include ::ManualSlug

    field :name, type: String
    manual_slug :name
    validates :name, :presence => true

    acts_as_nested_set
    scope :sorted, -> { order_by([:lft, :asc]) }

    belongs_to :category, :class_name => "MongoidForums::Category"
    validates :category, :presence => true

    has_many :topics, :class_name => "MongoidForums::Topic",  dependent: :destroy

    # Caching
    field :posts_count, :type => Integer


    has_and_belongs_to_many :moderator_groups, :class_name => "MongoidForums::Group", inverse_of: nil

    def unread_topic_count(user)
      view = View.where(:viewable_id => id, :user_id => user.id).first
      return topics.count unless view.present?
      count = 0
      topics.each do |topics|
        if topics.created_at > view.current_viewed_at
          count+=1
        end
      end
      return count
    end

    def count_of_posts
      topics.inject(0) {|sum, topic| topic.posts.count + sum }
    end

    def increment_posts_count
      if self.posts_count == nil
        self.posts_count = 1
      else
        self.posts_count += 1
      end
      self.save
    end


    def moderator?(user)
      return false unless user
      return true if category.moderator?(user)
      moderator_groups.each do |group|
        return true if group.moderator && group.members.include?(user.id)
      end
      false
    end

    def moderators
      array = Array.new
      self.moderator_groups.each do |g|
        array << g.group.members
      end
      return array
    end

    rails_admin do
      field :enabled, :toggle
      field :name
      field :created_at
      field :updated_at
      field :category
      field :posts_count
      field :moderator_groups

      nested_set({max_depth: 1})
    end
  end
end
