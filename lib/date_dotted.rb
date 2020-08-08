# frozen_string_literal: true

class Date
  # Dates in the form 19.4.2016
  class Dotted
    def initialize(str)
      @str = str
    end

    def to_ymd
      str.split('.').reverse.map { |num| num.rjust(2, '0') }.join('-')
    end

    private

    attr_reader :str
  end
end
