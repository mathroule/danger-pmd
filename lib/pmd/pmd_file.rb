# frozen_string_literal: true

class PmdFile
  require_relative "./pmd_violation"
  attr_accessor :file

  def initialize(file)
    @file = file
  end

  def source_path
    @source_path ||= file.attribute("name").value.to_s
  end

  def absolute_path
    dirname = File.basename(Dir.getwd)
    if source_path.index(dirname)
      index_start = source_path.index(dirname) + dirname.length + 1
    else
      index_start = 0
    end
    index_end = source_path.length
    @absolute_path ||= Pathname.new(source_path[index_start, index_end]).to_s
  end

  def violations
    @violations ||= file.xpath("violation").map do |pmd_violation|
      PmdViolation.new(pmd_violation)
    end
  end
end
