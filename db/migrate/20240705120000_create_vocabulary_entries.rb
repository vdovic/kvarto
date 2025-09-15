class CreateVocabularyEntries < ActiveRecord::Migration
  def change
    create_table :vocabulary_entries do |t|
      t.string :term, null: false
      t.string :translation
      t.text :example
      t.text :notes
      t.string :source_url
      t.integer :sheet_row_number
      t.datetime :last_synced_at

      t.timestamps
    end

    add_index :vocabulary_entries, :term, unique: true
  end
end
