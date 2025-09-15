require 'csv'
require 'net/http'
require 'uri'

class GoogleSheetVocabularyImporter
  class MissingConfigurationError < StandardError; end
  class ImportError < StandardError; end

  DEFAULT_COLUMN_MAPPING = {
    term: 'Term',
    translation: 'Translation',
    example: 'Example',
    notes: 'Notes'
  }.freeze

  attr_reader :url, :csv_data, :column_mapping

  def initialize(url:, csv_data: nil, column_mapping: {})
    @url = url
    @csv_data = csv_data
    @column_mapping = DEFAULT_COLUMN_MAPPING.merge(symbolize_keys(column_mapping))
  end

  def import
    raise MissingConfigurationError, 'A Google Sheet CSV URL must be provided.' if csv_content.blank?

    imported_count = 0

    CSV.parse(csv_content, headers: true).each_with_index do |row, index|
      term_value = cleaned_value(row[column_for(:term)])
      next if term_value.blank?

      entry = VocabularyEntry.find_or_initialize_by(term: term_value)
      entry.translation = cleaned_value(row[column_for(:translation)])
      entry.example = cleaned_value(row[column_for(:example)])
      entry.notes = cleaned_value(row[column_for(:notes)])
      entry.source_url = url if url.present?
      entry.sheet_row_number = index + 2
      entry.last_synced_at = Time.current

      entry.save!
      imported_count += 1
    end

    imported_count
  rescue CSV::MalformedCSVError => e
    raise ImportError, "The spreadsheet could not be parsed: #{e.message}"
  rescue StandardError => e
    raise ImportError, "The spreadsheet could not be imported: #{e.message}"
  end

  private

  def csv_content
    @csv_content ||= begin
      if csv_data.present?
        csv_data
      elsif url.present?
        fetch_from_url(url)
      end
    end
  end

  def fetch_from_url(target_url)
    uri = URI.parse(target_url)
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise ImportError, "Google Sheets responded with #{response.code}: #{response.message}"
    end

    body = response.body
    body.force_encoding('UTF-8') if body.respond_to?(:force_encoding)
    body
  rescue SocketError, Errno::ECONNREFUSED, Timeout::Error => e
    raise ImportError, "The spreadsheet could not be downloaded: #{e.message}"
  end

  def column_for(key)
    column_mapping[key] || DEFAULT_COLUMN_MAPPING[key]
  end

  def cleaned_value(value)
    value.is_a?(String) ? value.strip : value
  end

  def symbolize_keys(hash)
    return {} if hash.blank?

    hash.each_with_object({}) do |(key, value), memo|
      memo[key.to_sym] = value
    end
  end
end
