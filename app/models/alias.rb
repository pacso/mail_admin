class Alias < ActiveRecord::Base
  attr_accessible :local_part, :mailbox_id
  
  belongs_to :mailbox
  has_one :domain, through: :mailbox
  
  validates :local_part,  :presence => true
  validates :mailbox,     :presence => true
  
  def email
    [local_part, domain.name].join '@'
  end
end
