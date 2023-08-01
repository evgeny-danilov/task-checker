# frozen_string_literal: true

require 'shale' # https://github.com/kgiszczak/shale
require 'ostruct'

class Record < Shale::Mapper
  attribute :id, Shale::Type::Integer
  attribute :firstname, Shale::Type::String
  attribute :lastname, Shale::Type::String
  attribute :email, Shale::Type::Integer
  attribute :score, Shale::Type::Float
  attribute :date_of_birth, Shale::Type::String
  attribute :university, Shale::Type::String
end

# DataRec = Data.define(:id, :firstname, :lastname, :email, :score, :date_of_birth, :university)


class CsvParser
  def initialize(file_name:)
    @file_name = file_name
  end

  def call
    res = File.foreach(file_name)
    .lazy
    .map {
      id, firstname, lastname, email, score, date_of_birth, university = _1.split(',')
      Record.new(id: id, firstname: firstname, lastname: lastname, email: email,
                 score: score.to_f, date_of_birth: date_of_birth, university: university
      )
    }.reject { _1.id == 'id' }

    total = res.sum { _1.score }

    total / res.count
  end

  private

  attr_reader :file_name

end
