class Week < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments, allow_destroy: true

  def self.roles
    %w(primary_developer supplemental_developer infrastructure_developer oncall_weekday oncall_weekend )
  end

end
