class CreateLastReads < ActiveRecord::Migration[5.2]
  def change
    create_table :last_reads do |t|
      t.references :reader, foreign_key: {to_table: :users}
      t.references :message, foreign_key: true

      t.timestamps
    end
    add_index :last_reads, [:reader_id, :message_id], unique: true
  end
end
