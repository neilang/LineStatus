class RemoveCompositeValuesFromFeedback < ActiveRecord::Migration
  def self.up
    remove_column :feedbacks, :transport
    remove_column :feedbacks, :inbound
    rename_column :feedbacks, :line, :linedir
  end

  def self.down
    add_column :feedbacks, :transport, :string
    add_column :feedbacks, :inbound, :boolean
    rename_column :feedbacks, :linedir, :line
  end
end
