FactoryGirl.define do
  factory :task do
    # use blocks to not cache values
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline { Faker::Date.forward }
    done false
    # Factory girl sets a user automatically
    user
  end
end