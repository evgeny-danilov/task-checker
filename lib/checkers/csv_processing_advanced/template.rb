# frozen_string_literal: true

class CsvParserAdvanced

  def initialize(file_name:)
    @file_name = file_name
  end

  def call
    raise NotImplementedError
  end

  private

  attr_reader :file_name

end
