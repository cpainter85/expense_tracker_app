class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_type
      t.boolean :enabled, default: true
      t.decimal :credit_limit
      t.timestamps
    end
  end
end
