json.(reward, :id, :value)
json.is_archived reward.is_archived?
json.is_stale reward.stale?(current_user)
json.giver reward.giver.to_s
json.giver_path user_path(reward.giver)
json.recipient reward.recipient.to_s
json.recipient_path user_path(reward.recipient)
json.description emojify(reward.description)
json.created_at reward.created_at.to_s(:short)
