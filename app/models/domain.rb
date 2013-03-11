class Domain < ActiveRecord::Base
  attr_accessible :can_relay, :enabled, :name
  
  has_many :mailboxes
  
  validates :name,  :presence => true,
                    :uniqueness => true
end
