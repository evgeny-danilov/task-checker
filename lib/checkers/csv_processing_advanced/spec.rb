# frozen_string_literal: true

require 'rails_helper'
require_relative 'template'

module Checker
  RSpec.describe CsvParser do
    subject { described_class.new(file_name: file_name) }

    context 'when process csv file' do
      let(:file_name) { Rails.root.join('lib/checkers/csv_processing_advanced/short.csv') }

      it 'returns the valid result' do
        expect(subject.call).to include(
          'American University of Antigua' => 9.09,
          'Schiller International University' => 3.63,
          'Temple University (Rome campus)' => 3.5
        )
      end
    end

    context 'when parse big csv file' do
      let(:file_name) { Rails.root.join('lib/checkers/csv_processing_advanced/short.csv') }

      it 'works in the most efficient way' do
        RubyProf::FlatPrinter.new(
          RubyProf.profile(measure_mode: RubyProf::ALLOCATIONS) { subject.call }
        ).print(profiling = String.new)
        allocations = profiling.scan(/Total: (.+)/).flatten.first.to_i

        expect(allocations).to be < 1800
      end
    end

  end
end
