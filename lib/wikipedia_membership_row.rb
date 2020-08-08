# frozen_string_literal: true

require_relative './wikipedia_table_row'

# A Row in a Wikipedia Table of Members of the Legislature
class WikipediaMembershipRow < WikipediaTableRow
  field :id do
    wikidata_ids_in(name_cell).first
  end

  field :name do
    link_titles_in(name_cell).first
  end

  field :start_date do
    return unless start_date_str

    dateclass.new(start_date_str).to_ymd
  end

  field :end_date do
    return unless end_date_str

    dateclass.new(end_date_str).to_ymd
  end

  field :party do
    wikidata_ids_in(party_cell).first if party_cell
  end

  field :partyLabel do
    link_titles_in(party_cell).first if party_cell
  end

  field :constituency do
    wikidata_ids_in(constituency_cell).first if constituency_cell
  end

  field :constituencyLabel do
    link_titles_in(constituency_cell).first if constituency_cell
  end

  def empty?
    name.to_s.empty?
  end

  private

  def name_cell
    cell_for('name')
  end

  def party_cell
    cell_for('party')
  end

  def constituency_cell
    cell_for('constituency')
  end

  def start_date_cell
    cell_for('start_date')
  end

  def end_date_cell
    cell_for('end_date')
  end

  def start_date_str
    return unless start_date_cell

    start_date_cell.text.tidy
  end

  def end_date_str
    return unless end_date_cell

    end_date_cell.text.tidy
  end
end
