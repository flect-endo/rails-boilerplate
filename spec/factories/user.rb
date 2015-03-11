FactoryGirl.define do
  factory :admin, class: User do
    id 1
    name "admin"
    email "admin@flect.co.jp"
    password "password"
    password_confirmation "password"
    after(:build) { |admin| admin.skip_confirmation! }
  end

  factory :user, class: User do
    id 2
    name "user"
    email "user@flect.co.jp"
    password "password"
    password_confirmation "password"
    after(:build) { |user| user.skip_confirmation! }
  end
end