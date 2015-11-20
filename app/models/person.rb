class Person < ActiveRecord::Base
	has_many :assignments, dependent: :destroy
  validates :roles, presence: true
  validate :allowed_role
	validates :name, presence: true, length: { minimum: 2 }, uniqueness: true

  scope :with_role, ->(role) { where("roles @> ?", "{#{role}}") }

  def allowed_role
    if roles.present? && %w(primary_developer supplemental_developer infrastructure_developer oncall_weekday oncall_weekend).include?(roles)
      errors.add(:allowed_role, "value disallowed")
    end
  end

end
