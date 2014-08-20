FactoryGirl.define do
  factory :user do
    sequence(:name)  { |x| "Person #{x}" }
    sequence(:email) { |x| "person_#{x}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :admin_user do
      sequence(:name)  { "Mr_admin" }
      sequence(:email) { "admin@example.com"}
      password "foobar"
      password_confirmation "foobar"
    end
  end
end
