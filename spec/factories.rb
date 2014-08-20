FactoryGirl.define do
  factory :user do
    sequence(:name)  { |x| "Person #{x}" }
    sequence(:email) { |x| "person_#{x}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
