require 'support/features/user_helpers'
require 'support/features/chosen_helpers'

RSpec.configure do |config|
  config.include Features::UserHelpers, type: :feature
  config.include Features::ChosenHelpers, type: :feature
end