# frozen_string_literal: true

require_relative './wikipedia_table_row'

# A Row in a Wikipedia Table of Election Candidates
class WikipediaCandidateRow < WikipediaTableRow
  field :id do
    wikidata_ids_in(name_cell).first
  end

  field :name do
    (link_text_in(name_cell).first || name_cell.text).tidy
  end

  field :party do
    wikidata_ids_in(party_cell).first if party_cell
  end

  field :partyLabel do
    link_titles_in(party_cell).first if party_cell
  end

  field :votes do
    return unless votes_cell

    [plaintext_votes, anytext_votes].reject(&:empty?).first.to_s.tidy.gsub(/\D/,'')
  end

  def empty?
    (tds.count < columns.count) || (name.to_s.empty?)
  end

  private

  def name_cell
    cell_for('name')
  end

  def party_cell
    cell_for('party')
  end

  def votes_cell
    cell_for('votes')
  end

  def plaintext_votes
    votes_cell.xpath('./text()').text.tidy
  end

  def anytext_votes
    votes_cell.text.tidy
  end
end
