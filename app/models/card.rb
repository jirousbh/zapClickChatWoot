# == Schema Information
#
# Table name: cards
#
#  id                :integer          not null, primary key
#  color             :string           default("#A1B7BF")
#  conversation_uuid :uuid
#  description       :text
#  title             :string
#  uuid              :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer          not null
#  display_id        :integer          not null
#  label_id          :integer
#
# Indexes
#
#  index_cards_on_account_id  (account_id)
#  index_cards_on_uuid        (uuid) UNIQUE
#
class Card < ApplicationRecord
  belongs_to :account
  belongs_to :conversation, primary_key: :uuid, foreign_key: :conversation_uuid, inverse_of: :card
  belongs_to :label, optional: true

  def agent_name
    conversation.assignee.present? ? conversation.assignee.name : 'Não Atribuído a Colaborador'
  end

  def contact_name
    conversation.contact.present? ? conversation.contact.name : 'Nome não Cadastrado'
  end

  def can_schedule
    label.present? ? label.can_add_schedule : false
  end
end
