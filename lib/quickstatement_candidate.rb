# frozen_string_literal: true

require 'csv'

class String
  def quoted
    '"%s"' % self
  end
end

class QuickStatement
  class Candidate
    def initialize(result)
      @result = result
    end

    def to_s
      return existing_candidate_statement if result[:id]

      return [new_candidate_statements, existing_candidate_statement].join("\n") if result[:name]
    end

    private

    attr_reader :result

    def new_candidate_statements
      [
        'CREATE',
        ['LAST', 'P31', 'Q5'].join("\t"), # human
        ['LAST', 'Len', result[:name].tidy.quoted].join("\t"),
        ['LAST', 'Den', description.quoted].join("\t"),
        ['LAST', 'P106', 'Q19772737'].join("\t") # political candidate
      ].join("\n")
    end

    def existing_candidate_statement
      [result[:election], candidate, party, votes, reference].flatten.compact.join("\t")
    end

    def candidate
      ['P726', candidate_id]
    end

    def party
      ['P102', result[:party]] if result[:party]
    end

    def votes
      ['P1111', result[:votes]] if result[:votes]
    end

    def reference
      ['S4656', result[:url].quoted]
    end

    def candidate_id
      result[:id] || 'LAST'
    end

    def description
      result[:description] || 'politician'
    end
  end
end
