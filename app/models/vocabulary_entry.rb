class VocabularyEntry < ActiveRecord::Base
  validates :term, presence: true, uniqueness: true

  scope :search, ->(query) do
    if query.present?
      sanitized_query = "%#{query.to_s.downcase.strip}%"
      where('LOWER(term) LIKE :query OR LOWER(translation) LIKE :query', query: sanitized_query)
    else
      all
    end
  end

  def self.random_entry
    order('RANDOM()').first
  end

  def display_title
    term
  end
end
