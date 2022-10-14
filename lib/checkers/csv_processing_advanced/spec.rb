# frozen_string_literal: true

require 'rails_helper'
require_relative 'template'

module Checker
  RSpec.describe CsvParserAdvanced do
    subject { described_class.new(file_name: file_name) }

    context 'when process csv file' do
      let(:file_name) { Rails.root.join('lib/checkers/csv_processing_advanced/short.csv') }

      it 'returns the valid result' do
        expect(subject.call).to include(
          'American College of Thessaloniki (ACT)' => 4.69,
          'Schiller International University' => 3.63,
          'Temple University (Japan campus)' => 7.04
        )
      end

      it 'works in the most efficient way' do
        allocations = evaluate_allocations(RubyProf::ALLOCATIONS) { subject.call }

        expect(allocations).to be < 1800
      end
    end

    def evaluate_allocations(measure_mode, &block)
      RubyProf::FlatPrinter.new(
        RubyProf.profile(measure_mode: measure_mode, &block)
      ).print(profiling = String.new)

      profiling.scan(/Total: (.+)/).flatten.first.to_i.tap { print "=== #{_1}" }
    end

  end
end
