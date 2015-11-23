module MongoidForums
  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps
    include MongoidForums::Concerns::Subscribable
    include MongoidForums::Concerns::Viewable

    include Mongoid::Document
    include ::Mongoid::Timestamps

    include Enableable
    # include Seoable
    # include SortField

    include ::ManualSlug

    field :name, type: String
    manual_slug :name
    validates :name, :presence => true

    # acts_as_nested_set
    # scope :sorted, -> { order_by([:lft, :asc]) }

    after_create :subscribe_creator

    belongs_to :forum,  :class_name => "MongoidForums::Forum"
    has_many :posts,    :class_name => "MongoidForums::Post", dependent: :destroy

    belongs_to :user, :class_name => MongoidForums.user_class.to_s


    field :locked, type: Boolean, default: false
    field :pinned, type: Boolean, default: false
    field :hidden, type: Boolean, default: false

    validates :name, :presence => true, :length => { maximum: 255 }
    validates :user, :presence => true

    scope :by_most_recent_post,           order_by([:last_post_at, :desc])
    scope :by_pinned_or_most_recent_post, order_by([:pinned, :desc], [:last_post_at, :desc])

    def can_be_replied_to?
      !locked?
    end

    def toggle!(field)
      send "#{field}=", !self.send("#{field}?")
      save :validation => false
    end

    def unread_post_count(user)
      view = View.where(:viewable_id => id, :user_id => user.id).first
      return posts.count unless view.present?
      count = 0
      posts.each do |post|
        if post.created_at > view.current_viewed_at
          count+=1
        end
      end
      return count
    end

    rails_admin do
      field :enabled, :toggle
      field :locked, :toggle
      field :pinned, :toggle
      field :hidden, :toggle
      field :created_at
      field :updated_at
      # field :view_count
      field :name
      field :forum
      field :user
    end
  end
end
