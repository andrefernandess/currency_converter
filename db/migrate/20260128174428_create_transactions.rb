class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :user_id, null: false
      t.string :from_currency, null: false
      t.string :to_currency, null: false
      t.decimal :from_value, precision: 10, scale: 2, null: false
      t.decimal :to_value, precision: 10, scale: 2, null: false
      t.decimal :rate, precision: 10, scale: 6, null: false

      t.timestamps
    end

    add_index :transactions, :user_id
  end
end
