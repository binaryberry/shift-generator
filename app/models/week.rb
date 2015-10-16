class Week < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments, allow_destroy: true

  def self.roles
    %w(oncall_weekday oncall_weekend primarydev supplementaldev infrastructuredev)
  end

end
