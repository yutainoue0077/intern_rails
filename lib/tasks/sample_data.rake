namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "yuta inoue",
                     email: "yutainoue009@gmail.com",
                     password: "yutainoue007",
                     password_confirmation: "yutainoue007",
                     admin: true)
    50.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    30.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end
