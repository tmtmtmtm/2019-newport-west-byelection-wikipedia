class InputFile
  class Date
    def initialize(hash)
      @hash = hash
    end

    def to_s
      raise "Can't handle precision #{precision}" if precision < 9

      y_m_d.take(precision - 8).join('-')
    end

    private

    attr_reader :hash

    def raw
      hash[:value]
    end

    def precision
      hash[:precision].to_i
    end

    def ymd
      raw.sub('T00:00:00Z', '')
    end

    def y_m_d
      ymd.split('-')
    end
  end

  def initialize(pathname)
    @pathname = pathname
  end

  MAPPING = {
    id: %w[item],
    P4100: %w[party group],
    P768: %w[area constituency district],
    P580: %w[start starttime startdate start_time start_date],
    P582: %w[end endtime enddate end_time end_date],
    P1365: %w[replaces],
    P1366: %w[replaced_by replacedby replacedBy],
    P1534: %w[cause end_cause endcause endCause],
    P1545: %w[ordinal],
    P2715: %w[election electedin electedIn],
    P5054: %w[cabinet]
  }.freeze

  def data
    # TODO: warn about unexpected keys in either file
    @data ||= raw.map do |row|
      row.transform_keys { |k| remap.fetch(k.to_s, k).to_sym }
         .transform_values do |v|
        if v.class == Hash
          v = v[:precision] ? InputFile::Date.new(v).to_s : v[:value]
        end
        v
      end
    end
  end

  def find(id)
    data.select { |row| row[:id] == id }
  end

  def remap
    @remap ||= MAPPING.flat_map { |prop, names| names.map { |name| [name, prop.to_s] } }.to_h
  end

  def tally
    @tally ||= data.map { |r| r[:id] }.tally
  end

  attr_reader :pathname

  class CSV < InputFile
    require 'csv'

    def raw
      @raw ||= ::CSV.table(pathname).map(&:to_h)
    end
  end

  class JSON < InputFile
    require 'json'

    def raw
      @raw ||= ::JSON.parse(pathname.read, symbolize_names: true)
    end
  end
end
