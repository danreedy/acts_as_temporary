class CreateTemporaryObjects < ActiveRecord::Migration
  def change
    create_table :temporary_objects do |t|
      t.string :permanent_class
      t.text :definition

      t.timestamps
    end
  end
end
