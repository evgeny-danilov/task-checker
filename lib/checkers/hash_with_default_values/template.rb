# frozen_string_literal: true

class HashWithDefaultValues
  def initialize
    @hash = Hash.new { [] }
  end

  def call
    hash[:first] += ['item 1']
    hash[:second] += [ 'item 2']

    hash
  end

  private

  attr_accessor :hash
end
