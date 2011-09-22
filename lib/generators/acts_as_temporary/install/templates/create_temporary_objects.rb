class CreateTemporaryObjects < ActiveRecord::Migration
  def self.up
    create_table :temporary_objects do |t|
      t.string :permanent_class
      t.text :definition

      t.timestamps
    end
  end
  def self.down
    drop_table :temporary_objects
  end
end