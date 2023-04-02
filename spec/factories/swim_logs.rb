FactoryBot.define do
  factory :swim_log do
    user { nil }
    spot { nil }
    swim_date { "2023-04-02" }
    swim_time { "2023-04-02 16:51:06" }
    notes { "MyString" }
  end
end
