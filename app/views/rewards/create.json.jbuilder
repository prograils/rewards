if @reward.persisted?
  json.partial! 'reward', reward: @reward
else
  json.errors @reward.errors.full_messages.to_json
  json.error_string @reward.errors.full_messages.join("\n")
end
