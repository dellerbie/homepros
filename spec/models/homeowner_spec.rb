require 'spec_helper'

describe Homeowner do
  it { should validate_presence_of :email }
  it { should validate_presence_of(:city).with_message(/Please select a city closest to you/) }
  it { should ensure_length_of(:email).is_at_most(255) }
  it { should allow_value("d@d.com").for(:email) }
  it { should_not allow_value('d.com').for(:email) }
  
  [:email, :city_id, :received_flier].each do |attr|
    it { should allow_mass_assignment_of(attr) }
  end
end