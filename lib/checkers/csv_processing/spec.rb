# frozen_string_literal: true

require 'rails_helper'
require_relative 'template'

module Checker
  RSpec.describe CsvParser do
    subject { described_class.new(file_name: file_name) }

    context 'when process csv file' do
      let(:file_name) { Rails.root.join('lib/checkers/csv_processing/short.csv') }

      it 'returns the valid result' do
        expect(subject.call.round(2)).to eq(5.81)
      end

      it 'works in the most efficient way' do
        RubyProf::FlatPrinter.new(
          RubyProf.profile(measure_mode: RubyProf::MEMORY) { subject.call }
        ).print(profiling = String.new)
        allocations = profiling.scan(/Total: (.+)/).flatten.first.to_i

        expect(allocations).to be < 65_000
      end
    end

  end
end
