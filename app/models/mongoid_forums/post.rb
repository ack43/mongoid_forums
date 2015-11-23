module MongoidForums
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps

    include Enableable

    field :is_deleted, type: Boolean, default: false
    alias :deleted :is_deleted

    after_create :set_topic_last_post_at

    belongs_to :topic, :class_name => "MongoidForums::Topic"

    belongs_to :user, :class_name => MongoidForums.user_class.to_s

    belongs_to :reply_to, :class_name => "MongoidForums::Post"

    has_many :replies, :class_name => "MongoidForums::Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    field :text, type: String
    validates :text, :presence => true

    class << self
      def by_created_at
        order_by([:created_at, :asc])
      end

      def by_updated_at
        order_by([:updated_at, :desc])
      end
    end

    def owner_or_admin?(other_user)
      user == other_user || (other_user.mongoid_forums_admin? || topic.forum.moderator?(other_user))
    end

    rails_admin do
      field :enabled, :toggle
      field :is_deleted, :toggle
      field :created_at
      field :updated_at
      field :topic
      field :user
      field :text
    end

    protected
      def set_topic_last_post_at
        self.topic.update_attribute(:last_post_at, self.created_at)
      end
  end
end
