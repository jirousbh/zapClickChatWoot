class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards, id: :serial do |t|
      t.integer :display_id, null: false
      t.string :title
      t.text :description
      t.string :color, default: '#A1B7BF'
      t.uuid :uuid, default: -> { 'gen_random_uuid()' }, null: false
      t.integer :account_id, null: false
      t.integer :label_id
      t.uuid :conversation_uuid

      t.timestamps
    end

    add_index :cards, :account_id, name: 'index_cards_on_account_id'
    add_index :cards, :uuid, unique: true, name: 'index_cards_on_uuid'

    create_trigger('cards_before_insert_row_tr', generated: true, compatibility: 1)
      .on('cards').before(:insert).for_each(:row) do
        "NEW.display_id := nextval('conv_dpid_seq_' || NEW.account_id);"
      end
  end
end
