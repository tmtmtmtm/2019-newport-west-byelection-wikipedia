#!/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

require_relative 'lib/remove_notes'

require_relative 'lib/scraped_wikipedia_positionholders'
require_relative 'lib/wikipedia_candidates_page'
require_relative 'lib/wikipedia_candidate_row'

# The Wikipedia page with a list of candidates
class Candidates < WikipediaCandidatesPage
  decorator RemoveNotes
  decorator WikidataIdsDecorator::Links

  def wanted_tables
    noko.css('#Result').xpath('following::table[1]')
  end
end

# Each candidate in the list
class Candidate < WikipediaCandidateRow
  def columns
    %w[_color party name votes _percentage _diff]
  end
end

url = ARGV.first || abort("Usage: #{$0} <url to scrape>")
puts Scraped::Wikipedia::PositionHolders.new(url => Candidates).to_csv
