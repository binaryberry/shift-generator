class Assignment < ActiveRecord::Base
	belongs_to :week
  belongs_to :person

  def attribute(role)
    role = params(role)
  end
end
