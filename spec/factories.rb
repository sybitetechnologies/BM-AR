FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "#{SecureRandom.hex(16)}_#{n}@email#{n}.com"}
    password "password"
    password_confirmation "password"
  end

  factory :transaction do
    association :credited_user, factory: :user
    association :debited_user, factory: :user
    amount 20.0
  end
end