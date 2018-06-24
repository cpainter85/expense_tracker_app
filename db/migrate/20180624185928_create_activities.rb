class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.integer :account_id
      t.date :transaction_date
      t.string :merchant
      t.string :description
      t.boolean :cleared
      t.integer :category_id
      t.decimal :amount
      t.timestamps
    end
  end
end
