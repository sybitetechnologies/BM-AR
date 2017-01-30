class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer  :credited_user_id
      t.integer  :debited_user_id
      t.float    :amount
      t.string   :type     
      t.timestamps
    end
    add_index :transactions, :credited_user_id
    add_index :transactions, :debited_user_id
  end
end
