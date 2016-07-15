class Assignment < ActiveRecord::Base
  belongs_to :week
  belongs_to :person
end
