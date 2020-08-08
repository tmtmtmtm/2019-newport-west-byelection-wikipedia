# frozen_string_literal: true

require 'scraped'
require_relative 'wikipedia_page'

# A Wikipedia page with a list of officeholders
class WikipediaOfficeholderPage < WikipediaPage
  field :positionholders do
    office_holders_with_replacements
  end

  private

  def raw_office_holders
    @raw_office_holders ||= rows_as_fragments(HolderItem).map(&:to_h).uniq(&:to_s)
  end

  def office_holders_with_replacements
    raw_office_holders.each_cons(2) do |prev, cur|
      cur[:replaces] = prev[:id]
      prev[:replaced_by] = cur[:id]
    end
    raw_office_holders
  end
end
