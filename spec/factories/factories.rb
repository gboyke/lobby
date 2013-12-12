FactoryGirl.define do
  factory :user do
    email
    username
    password 'secret'
    password_confirmation 'secret'
    active true
  end
end

FactoryGirl.define do
  sequence :email do |n|
    names = %w[ joe bob sue ]
    "#{names[rand names.count]}#{n}@somewhere.com"
  end
end

FactoryGirl.define do
  sequence :username do |n|
    names = %w[ peterpan peterlustig guidoboyke mickymaus superhase spiegelei kaffeesatz ]
    "#{names[rand names.count]}"
  end
end
