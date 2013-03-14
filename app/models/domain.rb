class Domain < ActiveRecord::Base
  attr_accessible :can_relay, :enabled, :name
  
  has_many :mailboxes
  has_many :mailbox_aliases, through: :mailboxes
  has_many :mail_groups
  
  validates :name,  :presence => true,
                    :uniqueness => true

  def local_parts_not_belonging_to(obj)
    ( mailboxes.map{ |m| m.local_part unless m == obj } +
      mailbox_aliases.map{ |a| a.local_part unless a == obj} +
      mail_groups.map{ |g| g.local_part unless g == obj}
    ).compact
  end
end
