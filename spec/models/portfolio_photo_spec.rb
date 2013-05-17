require 'spec_helper'

describe PortfolioPhoto do
  it { should validate_presence_of :portfolio_photo }
  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_most(255) }
  it { should belong_to :listing }
end
