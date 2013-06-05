require 'support/features/user_helpers'
require 'support/features/chosen_helpers'
require 'support/features/common_helpers'

RSpec.configure do |config|
  config.include Features::UserHelpers, type: :feature
  config.include Features::ChosenHelpers, type: :feature
  config.include Features::CommonHelpers, type: :feature
  config.include Features::ListingHelpers, type: :feature
end