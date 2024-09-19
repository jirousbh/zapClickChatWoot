# == Schema Information
#
# Table name: labels
#
#  id               :bigint           not null, primary key
#  can_add_schedule :boolean          default(FALSE), not null
#  color            :string           default("#1f93ff"), not null
#  description      :text
#  final_step       :boolean          default(FALSE), not null
#  position         :integer
#  show_on_sidebar  :boolean
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint
#
# Indexes
#
#  index_labels_on_account_id            (account_id)
#  index_labels_on_title_and_account_id  (title,account_id) UNIQUE
#
class Label < ApplicationRecord
  include RegexHelper
  include AccountCacheRevalidator

  belongs_to :account
  acts_as_list scope: :account
  has_many :label_attributes, dependent: :destroy
  has_many :custom_attributes, through: :label_attributes, source: :custom_attribute_definition

  validates :title,
            presence: { message: I18n.t('errors.validations.presence') },
            format: { with: UNICODE_CHARACTER_NUMBER_HYPHEN_UNDERSCORE },
            uniqueness: { scope: :account_id }

  default_scope { order(:position) }

  scope :of_the_account, ->(account) { where(account: account) }

  before_validation do
    self.title = title.downcase if attribute_present?('title')
  end

  def conversations
    account.conversations.tagged_with(title)
  end

  def attributes_requireds
    custom_attributes.present? ? custom_attributes.pluck(:attribute_display_name).join(', ') : 'Nenhum Campo Atribuido'
  end

  def attributes_requireds_keys
    return [] if custom_attributes.blank?

    custom_attributes.map { |att| { attribute_key: att.attribute_key, attribute_name: att.attribute_display_name } }
  end

  def attribute_ids
    label_attributes.pluck(:custom_attribute_definition_id) || []
  end

  def properties
    []
  end

  def attributes_requireds_names
    custom_attributes.present? ? custom_attributes.pluck(:attribute_display_name) : []
  end

  def messages
    account.messages.where(conversation_id: conversations.pluck(:id))
  end

  def reporting_events
    account.reporting_events.where(conversation_id: conversations.pluck(:id))
  end

  private

  def update_associated_models
    return unless title_previously_changed?

    Labels::UpdateJob.perform_later(title, title_previously_was, account_id)
  end
end
