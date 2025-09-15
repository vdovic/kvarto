class VocabularyEntriesController < ApplicationController
  before_action :set_vocabulary_entry, only: [:show]

  def index
    @query = params[:query].to_s.strip
    entries_scope = VocabularyEntry.order(:term)
    entries_scope = entries_scope.search(@query)
    @entries = entries_scope.paginate(page: params[:page], per_page: 25)
  end

  def show
  end

  def study
    @entry = if params[:id].present?
               VocabularyEntry.find_by(id: params[:id])
             else
               VocabularyEntry.random_entry
             end

    if @entry.nil?
      redirect_to vocabulary_entries_path, alert: 'No vocabulary entries found. Please sync with your Google Sheet first.'
    end
  end

  def sync
    sheet_url = params[:sheet_url].presence || ENV['GOOGLE_SHEET_CSV_URL']
    csv_payload = params[:csv_data]
    importer = GoogleSheetVocabularyImporter.new(url: sheet_url, csv_data: csv_payload, column_mapping: column_mapping_params)
    imported_count = importer.import

    redirect_to vocabulary_entries_path, notice: "Imported #{imported_count} vocabulary entries from Google Sheets."
  rescue GoogleSheetVocabularyImporter::MissingConfigurationError, GoogleSheetVocabularyImporter::ImportError => e
    redirect_to vocabulary_entries_path, alert: e.message
  end

  private

  def set_vocabulary_entry
    @entry = VocabularyEntry.find(params[:id])
  end

  def column_mapping_params
    return {} unless params[:column_mapping].present?

    params.require(:column_mapping).permit(:term, :translation, :example, :notes)
  end
end
