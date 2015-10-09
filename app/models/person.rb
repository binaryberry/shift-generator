class Person < ActiveRecord::Base
	validates :roles, presence: true, inclusion: { in: %w(oncall_weekday oncall_weekend primarydev supplementaldev infrastructuredev)}
	validates :name, presence: true, length: { minimum: 2 }
end
