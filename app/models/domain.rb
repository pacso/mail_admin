class Domain < ActiveRecord::Base
  attr_accessible :can_relay, :enabled, :name
  
  has_many :mailboxes
  has_many :aliases, through: :mailboxes
  
  validates :name,  :presence => true,
                    :uniqueness => true

  def local_parts_not_belonging_to(obj)
    (mailboxes.map{ |m| m.local_part unless m == obj } + aliases.map{ |a| a.local_part unless a == obj}).compact
  end
end
