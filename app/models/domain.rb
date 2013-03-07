class Domain < ActiveRecord::Base
  attr_accessible :can_relay, :enabled, :name
end
