# frozen_string_literal: true

require 'csv'

class CsvParser
  def initialize(file_name:)
    @file_name = file_name
  end

  def call
    raise NotImplementedError
  end

  private

  attr_reader :file_name

end
