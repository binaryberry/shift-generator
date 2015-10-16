class Person < ActiveRecord::Base
	has_many :assignments, dependent: :destroy
  validates :roles, presence: true
  validate :allowed_role
	validates :name, presence: true, length: { minimum: 2 }, uniqueness: true

  scope :with_role, ->(role) { where("roles @> ?", "{#{role}}") }

  def allowed_role
    if roles.present? && %w(oncall_weekday oncall_weekend primarydev supplementaldev infrastructuredev).include?(roles)
      errors.add(:allowed_role, "value disallowed")
    end
  end

end
