# frozen_string_literal: true

class PmdViolation
  PRIORITY_ERROR_THRESHOLD = 2
  attr_accessor :violation

  def initialize(violation)
    @violation = violation
  end

  def priority
    @priority ||= violation.attribute("priority").value.to_i
  end

  def type
    @type ||= priority < PRIORITY_ERROR_THRESHOLD ? :warn : :fail
  end

  def line
    @line ||= violation.attribute("beginline").value.to_i
  end

  def description
    @description ||= violation.text.gsub("\n", "")
  end
end
