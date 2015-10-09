class Week < ActiveRecord::Base
  after_create :create_assignments
  has_many :assignments

ROLES = %w(oncall_weekday oncall_weekend primarydev supplementaldev infrastructuredev)

	def create_assignments
		ROLES.each do |role|
			assignments.create(role: role)
		end
	end

end
