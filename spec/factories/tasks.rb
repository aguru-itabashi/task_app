FactoryBot.define do
  factory :task do
    name {"テストを書く"}
    description {"Rspec使ってテストを書こう"}
    user
  end
end
