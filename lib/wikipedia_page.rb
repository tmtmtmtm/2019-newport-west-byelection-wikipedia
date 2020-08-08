# frozen_string_literal: true

require 'scraped'

# A page from a Wikipedia, that might contain some tables
class WikipediaPage < Scraped::HTML
  private

  def tables_with_header(str)
    noko.xpath(format('.//table[.//th[contains(
      translate(., "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"),
    "%s")]]', str.downcase))
  end

  def rows_as_fragments(klass)
    wanted_tables.xpath('.//tr[td]').map { |tr| fragment(tr => klass) }.reject(&:empty?)
  end
end
