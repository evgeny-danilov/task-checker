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
    end

    context 'when process big csv file' do
      let(:file_name) { Rails.root.join('lib/checkers/csv_processing/10MB.csv') }

      it 'parse file in the most effective way', aggregate_failures: true do
        subject.call
        objects_allocations, heap_memory_usage = nil

        processing_time = evaluate_processing_time do
          heap_memory_usage = evaluate_heap_memory_usage do
            objects_allocations = evaluate_allocations(RubyProf::ALLOCATIONS) do
              subject.call
            end
          end
        end

        expect(heap_memory_usage).to be < 2_000
        expect(objects_allocations).to be < 2_000_000
        expect(processing_time).to be < 2.seconds
      end
    end

    def evaluate_processing_time(&block)
      Benchmark.measure(&block).utime
    end

    def evaluate_heap_memory_usage(&block)
      profiler = garbage_collector_profiler(&block)
      heap_use_size_array = profiler.filter_map { _1[:HEAP_USE_SIZE] if _1[:HEAP_USE_SIZE] > 0 }

      heap_use_size_array.max - heap_use_size_array.min
    end

    def evaluate_allocations(measure_mode, &block)
      RubyProf::FlatPrinter.new(
        RubyProf.profile(measure_mode: measure_mode, &block)
      ).print(profiling = String.new)

      profiling.scan(/Total: (.+)/).flatten.first.to_i
    end

    def garbage_collector_profiler
      GC::Profiler.enable
      yield
      profiler = GC::Profiler.raw_data
      GC::Profiler.disable
      GC::Profiler.clear

      profiler
    end

  end
end
