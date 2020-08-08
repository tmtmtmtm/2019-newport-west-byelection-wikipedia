# Subclass of Scraped::HTML specifically for a row in a Wikipedia table
class WikipediaTableRow < Scraped::HTML
  def tds
    noko.css('td,th')
  end

  def table_headings
    # don't cache, as there may be multiple tabless with different layouts
    noko.xpath('ancestor::table//tr[.//th]//th').map(&:text).map(&:tidy)
  end

  def columns_headed(str)
    table_headings.each_with_index.select { |heading, index| heading.include?(str) }.map(&:last)
  end

  def cells_headed(str)
    tds.to_a.values_at(*columns_headed(str))
  end

  def wikidata_ids_in(node)
    node.css('a/@wikidata').map(&:text)
  end

  def link_titles_in(node)
    node.css('a/@title').map(&:text).map(&:tidy)
  end

  def link_text_in(node)
    node.css('a').map(&:text).map(&:tidy)
  end

  def cell_for(str)
    ifx = columns.index(str) or return
    tds[ifx]
  end
end
