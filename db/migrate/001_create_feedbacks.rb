class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.string :line, null: false
      t.string :transport, null: false
      t.boolean :inbound
      t.integer :status, default: 0, null: false
      t.string :udid, length: 40
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
