class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.references :message, foreign_key: true
      t.references :tagged, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
