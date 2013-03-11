require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe "class_for_alert_type" do
    it "returns the correct class for notice flash messages" do
      expect(helper.class_for_alert_type('notice')).to eq "success"
    end
    
    it "returns the correct class for alert flash messages" do
      expect(helper.class_for_alert_type('alert')).to eq "error"
    end
  end
end
