# frozen_string_literal: true

class CsvParser
  def initialize(file_name:)
    @file_name = file_name
  end

  def call
    File.foreach(file_name)
        .lazy
        .map { _1.split(',').values_at(0,4) }
        .reject { _1.first == 'id' }
        .inject(Acc.new, &method(:accumulate))
        .average
  end

  private

  attr_reader :file_name

  def accumulate(acc, row)
    acc.tap { _1.add!(row.last.to_f) }
  end

  class Acc
    def initialize
      @count = 0
      @sum = 0.0
    end

    attr_reader :count, :sum

    def add!(item)
      @count += 1
      @sum += item
    end

    def average
      sum / count
    end
  end

end
