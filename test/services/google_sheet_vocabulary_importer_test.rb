require 'test_helper'

class GoogleSheetVocabularyImporterTest < ActiveSupport::TestCase
  SAMPLE_CSV = <<-CSV
Term,Translation,Example,Notes
Hello,Привіт,Hello there!,Greeting someone with a smile.
CSV

  test 'imports new vocabulary entries' do
    importer = GoogleSheetVocabularyImporter.new(url: 'http://example.com', csv_data: SAMPLE_CSV)

    assert_difference 'VocabularyEntry.count', 1 do
      importer.import
    end

    entry = VocabularyEntry.find_by(term: 'Hello')
    assert_not_nil entry
    assert_equal 'Привіт', entry.translation
    assert_equal 'Hello there!', entry.example
    assert_equal 'Greeting someone with a smile.', entry.notes
    assert_equal 2, entry.sheet_row_number
    assert_equal 'http://example.com', entry.source_url
    assert_not_nil entry.last_synced_at
  end

  test 'updates existing entries when the term already exists' do
    csv_data = <<-CSV
Term,Translation,Example,Notes
Hello,Привіт!,Updated example,Updated notes
CSV

    importer = GoogleSheetVocabularyImporter.new(url: 'http://example.com', csv_data: csv_data)

    assert_no_difference 'VocabularyEntry.count' do
      importer.import
    end

    entry = VocabularyEntry.find_by(term: 'Hello')
    assert_equal 'Привіт!', entry.translation
    assert_equal 'Updated example', entry.example
    assert_equal 'Updated notes', entry.notes
  end

  test 'supports custom column mapping' do
    csv_data = <<-CSV
Word,Meaning
Sunshine,сонце
CSV

    importer = GoogleSheetVocabularyImporter.new(
      url: 'http://example.com',
      csv_data: csv_data,
      column_mapping: { term: 'Word', translation: 'Meaning' }
    )

    importer.import

    entry = VocabularyEntry.find_by(term: 'Sunshine')
    assert_not_nil entry
    assert_equal 'сонце', entry.translation
  end

  test 'raises an error when no URL or data is provided' do
    importer = GoogleSheetVocabularyImporter.new(url: nil, csv_data: '')

    assert_raises GoogleSheetVocabularyImporter::MissingConfigurationError do
      importer.import
    end
  end
end
