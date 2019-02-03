class UserSimpleSerializer
  include FastJsonapi::ObjectSerializer
  set_type :user  # optional

  attributes :id,:first_name,:last_name
end
