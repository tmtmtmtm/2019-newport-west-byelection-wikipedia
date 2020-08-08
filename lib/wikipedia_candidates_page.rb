# frozen_string_literal: true

require 'scraped'
require_relative 'wikipedia_page'

# A Wikipedia table with a list of election candidates
class WikipediaCandidatesPage < WikipediaPage
  field :rows do
    rows_as_fragments(Candidate).map(&:to_h)
  end

  field :total_votes do
    wanted_tables.css('td').find { |td| td.text == 'Total' }.xpath('following-sibling::td').map(&:text).map(&:tidy).reject(&:empty?).first.gsub(/\D/,'')
  end

  field :invalid_votes do
    wanted_tables.css('td').find { |td| td.text.include? 'Invalid/blank' }.xpath('following-sibling::td').map(&:text).map(&:tidy).reject(&:empty?).first.gsub(/\D/,'')
  end

  field :registered_voters do
    wanted_tables.css('td').find { |td| td.text.include? 'Registered voters' }.xpath('following-sibling::td').map(&:text).map(&:tidy).reject(&:empty?).first.gsub(/\D/,'')
  end
end
