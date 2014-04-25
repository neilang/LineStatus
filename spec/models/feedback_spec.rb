require 'spec_helper'

describe Feedback do

  it "should validate a required fields are set" do
    m = Feedback.new; m.valid?

    m.errors.should have_key(:line)
    m.errors.should have_key(:transport)
    m.errors.should have_key(:udid)
  end

  it "defaults to being 'on time'" do
    m = Feedback.new
    m.on_time?.should   be_true
    m.cancelled?.should be_false
    m.late?.should      be_false
    m.very_late?.should be_false
    m.early?.should     be_false
  end

end
