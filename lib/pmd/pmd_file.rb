class PmdFile
  require_relative './pmd_violation'
  attr_accessor :module_name
  attr_accessor :file

  def initialize(module_name, file)
    @module_name = module_name
    @file = file
  end

  def source_path
    @source_path ||= file.attribute("name").value.to_s
  end

  def absolute_path
    @absolute_path ||= Pathname.new(source_path[source_path.index(module_name), source_path.length]).to_s
  end

  def violations
    @violations ||= file.xpath("violation").map do |pmd_violation|
      PmdViolation.new(module_name, pmd_violation)
    end
  end

end
