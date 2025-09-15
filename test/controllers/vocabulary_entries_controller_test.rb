require 'test_helper'

class VocabularyEntriesControllerTest < ActionController::TestCase
  setup do
    @entry = vocabulary_entries(:sample)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test 'should show entry' do
    get :show, id: @entry
    assert_response :success
  end

  test 'should get study view when entries exist' do
    get :study
    assert_response :success
    assert assigns(:entry)
  end

  test 'should redirect study when no entries available' do
    VocabularyEntry.delete_all
    get :study
    assert_redirected_to vocabulary_entries_path
    assert_equal 'No vocabulary entries found. Please sync with your Google Sheet first.', flash[:alert]
  end

  test 'should sync from csv payload' do
    VocabularyEntry.delete_all
    csv_payload = "Term,Translation\nFocus,концентрація\n"

    assert_difference 'VocabularyEntry.count', 1 do
      post :sync, csv_data: csv_payload
    end

    assert_redirected_to vocabulary_entries_path
    assert_equal 'Imported 1 vocabulary entries from Google Sheets.', flash[:notice]
  end
end
