require 'test_helper'

class VocabularyEntryTest < ActiveSupport::TestCase
  def setup
    @sample = vocabulary_entries(:sample)
  end

  test 'is invalid without a term' do
    entry = VocabularyEntry.new(translation: 'Test')
    assert entry.invalid?
    assert_includes entry.errors[:term], "can't be blank"
  end

  test 'enforces uniqueness on term' do
    duplicate = VocabularyEntry.new(term: @sample.term)
    assert duplicate.invalid?
    assert_includes duplicate.errors[:term], 'has already been taken'
  end

  test 'search finds matches in term and translation' do
    entry = VocabularyEntry.create!(term: 'Sunflower', translation: 'соняшник')
    assert_includes VocabularyEntry.search('sun'), entry
    assert_includes VocabularyEntry.search('сон'), entry
  end

  test 'search returns all entries when query blank' do
    expected_ids = VocabularyEntry.order(:term).map(&:id)
    actual_ids = VocabularyEntry.search(nil).order(:term).map(&:id)
    assert_equal expected_ids, actual_ids
  end
end
