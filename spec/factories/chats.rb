FactoryBot.define do
  factory :chat do
    message { "My Text" }
    association :help
    user_id { 1 }
  end
end
