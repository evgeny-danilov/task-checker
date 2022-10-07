# frozen_string_literal: true

class File2

  InvalidFileError = Class.new(StandardError)

  def initialize(file_name)
    check_file!(file_name)

    File.new(file_name)
  end

  class << self
    def open(file_name)
      check_file!(file_name)

      File.open(file_name)
    end

    def foreach(file_name)
      check_file!(file_name)

      File.foreach(file_name)
    end

    def each(file_name)
      check_file!(file_name)

      File.each(file_name)
    end

    def readlines(file_name)
      check_file!(file_name)

      File.readlines(file_name)
    end
  end

  private

  def self.check_file!(file_name)
    checkers_path = ::CheckController::CHECKERS_PATH.to_s
    return if File.expand_path(file_name).start_with?(checkers_path)

    raise InvalidFileError, 'Please, use only files in ' + checkers_path
  end

  def check_file!(file_name)
    self.class.check_file!(file_name)
  end

end
