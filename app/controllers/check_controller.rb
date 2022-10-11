class CheckController < ApplicationController
  CHECKERS_PATH = Rails.root.join('lib/checkers') # TODO: move to global constants

  def index
    @tasks = Dir.entries(CHECKERS_PATH).reject { _1.start_with?('.') }.sort
  end

  def show
    @test_content = File.read(task_path)[/RSpec.+/m]
    @template = params[:template] || File.read(template_path)
    @error_message = params[:error_message]
    @description = YAML.load(File.read(meta_path)).fetch('description')
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

    redirect_to action: :show,
                result: test_evaluation.result.zero? ? 'success' : 'failed',
                template: provided_solution.gsub(/File2/, 'File').gsub(/CSV2/, 'CSV'),
                error_message: test_evaluation.outputs
  end

  private

  def task_path
    File.join(CHECKERS_PATH, task_name, 'spec.rb')
  end

  def template_path
    File.join(CHECKERS_PATH, task_name, 'template.rb')
  end

  def meta_path
    File.join(CHECKERS_PATH, task_name, 'meta.yml')
  end

  def task_name
    params[:id]
  end

  def provided_solution
    stop_list = %w[
      exec system eval send byebug binding pry write IO FileUtils FileTest Dir DIR __ @@ `
      Rails config Config ENV ActiveRecord Application Controller RSpec
    ].freeze
    guard_regexp = Regexp.new(stop_list.join('|'))

    params.dig('check', 'solution')
          .gsub(guard_regexp, '###')
          .gsub(/File/, 'File2')
          .gsub(/CSV/, 'CSV2')
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

      OpenStruct.new(result: result, errors: errors, outputs: formatted_output(outputs))
    end

    def self.formatted_output(output)
      examples_result = output.examples.map.with_index(1) do |example, index|
        description = index.to_s + ': ' + example.description.titleize
        next (description + ': Passed') if example.status == 'passed'

        description + "\n" + example.exception.message
      end

      examples_result.join("\n\n") + "\n\n" + output.summary_line
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
