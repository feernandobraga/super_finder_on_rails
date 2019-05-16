class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :term
      t.string :path
      t.text :sample

      t.timestamps
    end
  end
end
