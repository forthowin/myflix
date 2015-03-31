Fabricator(:invitation) do
  recipient_email { Faker::Internet.email }
  recipient_name { Faker::Name.name }
  message { Faker::Lorem.paragraph }
  inviter { Fabricate(:user) }
end