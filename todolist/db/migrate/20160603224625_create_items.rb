class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :content
      t.integer :priority
      t.boolean :done, default: false
    end
  end
end
