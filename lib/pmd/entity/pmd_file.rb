# frozen_string_literal: true

# Represent a PMD file.
class PmdFile
  require_relative './pmd_violation'

  attr_accessor :file

  # An absolute path to this file
  #
  # @return [String]
  attr_reader :absolute_path

  # A relative path to this file
  #
  # @return [String]
  attr_reader :relative_path

  def initialize(prefix, file)
    @file = file
    @absolute_path = file.attribute('name').value.to_s

    prefix += (prefix.end_with?(file_separator) ? '' : file_separator)
    @relative_path = if @absolute_path.start_with?(prefix)
                       @absolute_path[prefix.length, @absolute_path.length - prefix.length]
                     else
                       @absolute_path
                     end
  end

  def violations
    @violations ||= file.xpath('violation').map do |pmd_violation|
      PmdViolation.new(pmd_violation)
    end
  end

  private

  def file_separator
    File::ALT_SEPARATOR || File::SEPARATOR
  end
end
