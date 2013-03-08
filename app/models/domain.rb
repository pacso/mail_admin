class Domain < ActiveRecord::Base
  attr_accessible :can_relay, :enabled, :name
  
  validates :name,  :presence => true,
                    :uniqueness => true
end
