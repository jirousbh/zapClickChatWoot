json.array! @cards do |card|
  json.id card.id
  json.conversation_id card.conversation.display_id
  json.title card.title
  json.status card.title
  json.description card.description
  json.contact_avatar card.contact_avatar
  json.team_id card.conversation.get_team_id
  json.agent_name card.agent_name
  json.contact_name card.contact_name
  json.custom_attributes card.conversation.custom_attributes
  json.label_attributes card.conversation.label_attributes
  json.label_id card.conversation.label.id if card.conversation.label.present?
  json.color card.color
  json.label_title card.conversation.label_title
  json.can_schedule card.conversation.can_schedule
  json.team_id card.conversation.get_team_id
  json.account_id card.conversation.account_id
  json.uuid card.uuid
  json.conversation_uuid card.conversation.uuid
  json.additional_attributes card.conversation.additional_attributes
  json.agent_last_seen_at card.conversation.agent_last_seen_at.to_i
  json.assignee_last_seen_at card.conversation.assignee_last_seen_at.to_i
  json.can_reply card.conversation.can_reply?
  json.contact_last_seen_at card.conversation.contact_last_seen_at.to_i
  json.custom_attributes card.conversation.custom_attributes
  json.inbox_id card.conversation.inbox_id
  json.muted card.conversation.muted?
  json.snoozed_until card.conversation.snoozed_until
  json.status card.conversation.status
  json.created_at card.conversation.created_at.to_i
  json.timestamp card.conversation.last_activity_at.to_i
  json.first_reply_created_at card.conversation.first_reply_created_at.to_i
  json.unread_count card.conversation.unread_incoming_messages.count
  json.last_non_activity_message card.conversation.messages.where(account_id: card.conversation.account_id).non_activity_messages.first.try(:push_event_data)
  json.last_activity_at card.conversation.last_activity_at.to_i
  json.priority card.conversation.priority
  json.waiting_since card.conversation.waiting_since.to_i.to_i
  json.sla_policy_id card.conversation.sla_policy_id
end
