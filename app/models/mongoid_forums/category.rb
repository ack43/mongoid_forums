module MongoidForums
  class Category
    include Mongoid::Document
    include ::Mongoid::Timestamps

    include Enableable
    # include Seoable
    include SortField

    include ::ManualSlug

    field :name, type: String
    manual_slug :name
    validates :name, :presence => true

    acts_as_nested_set
    scope :sorted, -> { order_by([:lft, :asc]) }

    has_many :forums, :class_name => "MongoidForums::Forum",  dependent: :destroy
    has_and_belongs_to_many :moderator_groups, :class_name => "MongoidForums::Group", inverse_of: nil

    def moderator?(user)
      return false unless user
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
      field :moderator_groups

      nested_set({max_depth: 1})
    end
  end
end
