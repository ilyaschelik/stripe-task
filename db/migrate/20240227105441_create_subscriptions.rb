class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def up
    create_table :subscriptions do |t|
      t.string :subscription_id, null: false
      t.string :customer_id
      t.string :customer_name
      t.string :customer_email
      t.string :status
    
      t.timestamps
    end
  end

  def down 
    drop_table :subscriptions
  end
end
