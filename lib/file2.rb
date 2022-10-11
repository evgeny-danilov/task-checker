# frozen_string_literal: true

class File2

  InvalidFilePathError = Class.new(StandardError)

  class << self
    AVAILABLE_METHODS = %i(new open read foreach readlines).freeze

    AVAILABLE_METHODS.each do |method_name|
      define_method(method_name) do |file_name, options = {}, &block|
        validate_file_path!(file_name)

        File.send(method_name, file_name, **options, &block)
      end
    end

    private

    def validate_file_path!(file_name)
      checkers_path = ::CheckController::CHECKERS_PATH.to_s
      return if File.expand_path(file_name).start_with?(checkers_path)

      raise InvalidFilePathError, 'Please, use only files in ' + checkers_path
    end
  end

end
