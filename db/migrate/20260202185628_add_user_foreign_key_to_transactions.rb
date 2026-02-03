class AddUserForeignKeyToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :transactions, :users
  end
end
