# frozen_string_literal: true

require 'rails_helper'
require_relative 'template'

module Checker
  RSpec.describe HashWithDefaultValues do
    subject(:hash) { described_class.new.call }

    context 'when ruby Hash initialized with default value as an empty array' do
      it 'produces the default value by any key' do
        random_key = Random.rand(10000)
        expect(hash[random_key]).to eq([])
      end

      it 'allows to modify default values without side-effects' do
        expect(hash[:first]).to eq(['item 1'])
        expect(hash[:second]).to eq(['item 2'])
        expect(hash[:random]).to eq([])
      end

      it 'produces a uniq Ruby object by any key' do
        expect(hash[:first].object_id).not_to eq(hash[:second].object_id)
      end
    end

  end
end
