# frozen_string_literal: true

require 'scraped'
require_relative 'wikipedia_page'

# A Wikipedia page with a list of members of a legislature
class WikipediaMembersPage < WikipediaPage
  field :positionholders do
    rows_as_fragments(MembershipRow).map(&:to_h)
  end
end
