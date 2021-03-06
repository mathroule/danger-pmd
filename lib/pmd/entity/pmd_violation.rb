# frozen_string_literal: true

# Represent a PMD violation.
class PmdViolation
  PRIORITY_ERROR_THRESHOLD = 4
  attr_accessor :violation

  def initialize(violation)
    @violation = violation
  end

  def priority
    @priority ||= violation.attribute('priority').value.to_i
  end

  def type
    @type ||= priority < PRIORITY_ERROR_THRESHOLD ? :warn : :fail
  end

  def line
    @line ||= violation.attribute('beginline').value.to_i
  end

  def description
    @description ||= violation.text.gsub("\n", '')
  end
end
