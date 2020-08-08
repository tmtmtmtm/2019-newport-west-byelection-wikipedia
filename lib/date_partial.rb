# frozen_string_literal: true

class Date
  # Dates in the form "19 April 2016", but possibly missing components
  # (e.g. "April 2016" or "2016")
  class Partial
    def initialize(str)
      @str = str.tidy
    end

    def to_ymd
      # There must be a nicer way to do this
      shorttext.split('-').map { |num| num.rjust(2, '0') }.join('-')
    end

    private

    attr_reader :str

    def parts
      str.split(' ').reverse
    end

    def longtext
      parts.join('-')
    end

    def shorttext
      longtext.gsub(MONTHS_RE) { |name| MONTHS.find_index(name) }
    end

    MONTHS = %w[NULL January February March April May June July August September October November December].freeze
    MONTHS_RE = Regexp.new(MONTHS.join('|'))
  end
end
