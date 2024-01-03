class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision:8, scale:2
      t.text :description
      t.datetime :date

      t.timestamps
    end
  end
end
