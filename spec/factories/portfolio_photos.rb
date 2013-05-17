# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :portfolio_photo do
    description 'some description'
    portfolio_photo { File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'guitar.jpg')) }
  end
end
