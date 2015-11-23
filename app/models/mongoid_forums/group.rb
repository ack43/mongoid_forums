module MongoidForums
  class Group
    include Mongoid::Document
    include ::Mongoid::Timestamps

    include Enableable

    validates :name, :moderator, :presence => true

    field :name, type: String
    field :moderator, type: Boolean
    has_and_belongs_to_many :members, class_name: MongoidForums.user_class.to_s, inverse_of: nil

    def to_s
      name
    end

    rails_admin do
      field :enabled, :toggle
      field :name
      field :created_at
      field :updated_at
      field :moderator
      field :members
    end
  end
end
