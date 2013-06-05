require 'spec_helper'

feature 'Edit premium listing photos', js: true do
  
  scenario 'can edit up to 6 photos'
  scenario 'delete a photo'
  scenario "can't delete all photos"
  scenario 'update description'
  scenario 'update photo'
  
end