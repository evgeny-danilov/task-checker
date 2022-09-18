class CheckController < ApplicationController
  CHECKERS_PATH = Rails.root.join('lib/checkers')

  def index
    @tasks = Dir.entries(CHECKERS_PATH).reject { _1.in?(%w[. ..]) }
  end

  def show
    @test_content = File.read(task_path)[/RSpec.+/m]
    @template = File.read(template_path)
    @error_message = params[:error_message]
  end

  def evaluate
    Object.const_set('Checker', Module.new)
    begin
      ::Checker.module_eval(provided_solution)
    rescue SyntaxError
      nil
    end
    test_evaluation = CheckRunner.call(task_path: task_path)
    Object.send(:remove_const, 'Checker')

    error_message = test_evaluation.outputs.messages
    error_message ||= test_evaluation.outputs&.examples&.map { _1.exception&.message }

    redirect_to action: :show,
                result: test_evaluation.result.zero? ? 'success' : 'failed',
                error_message: error_message&.join('. ').truncate(150)
  end

  private

  def task_path
    File.join(CHECKERS_PATH, task_name, 'spec.rb')
  end

  def template_path
    File.join(CHECKERS_PATH, task_name, 'template.rb')
  end

  def task_name
    params[:id]
  end

  def provided_solution
    stop_list = %w[eval sql send rails config activerecord application env].freeze
    guard_regexp = Regexp.new(stop_list.join('|'), Regexp::IGNORECASE)

    params.dig('check', 'solution').gsub(guard_regexp, '###')
  end

  class CheckRunner
    def self.call(task_path:)
      require 'rspec/core'

      error_stream = StringIO.new
      output_stream = StringIO.new

      result = RSpec::Core::Runner.run([task_path, '--format', 'json'], error_stream, output_stream)
      RSpec.reset

      errors = JSON.parse(error_stream.string, { object_class: OpenStruct }) if error_stream.string.present?
      outputs = JSON.parse(output_stream.string, { object_class: OpenStruct }) if output_stream.string.present?

      OpenStruct.new(result: result, errors: errors, outputs: outputs)
    end

    # Other approach is to use Mini-tests:
    # https://docs.knapsackpro.com/2018/how-to-run-tests-in-minitest-continuously-with-dynamic-test-files-loading
    #
    # Check Travis
    # How to build custom code in the container?
    #
    # It might be helpful:
    # https://github.com/heroku/logplex/blob/master/.travis.yml
  end
end
