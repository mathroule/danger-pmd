# frozen_string_literal: true

module Danger
  # Checks on your Gradle project's Java source files.
  # This is done using [PMD](https://pmd.github.io)
  # Results are passed out as tables in markdown.
  #
  # @example Running PMD with its basic configuration
  #
  #          pmd.report
  #
  # @example Running PMD with a specific Gradle task or report_file
  #
  #          pmd.gradle_task = 'app:pmd' #defalut: pmd
  #          pmd.report_file = "app/build/reports/pmd/pmd.xml"
  #          pmd.report
  #
  # @see mathroule/danger-pmd
  # @tags java, android, pmd

  class DangerPmd < Plugin
    require_relative "./pmd_file"

    # Custom Gradle module to run.
    # This is useful when your project has different flavors.
    # Defaults to "app".
    # @return [String]
    attr_writer :gradle_module

    # Custom Gradle task to run.
    # This is useful when your project has different flavors.
    # Defaults to "pmd".
    # @return [String]
    attr_writer :gradle_task

    # Location of report file
    # If your pmd task outputs to a different location, you can specify it here.
    # Defaults to "build/reports/pmd/pmd.xml".
    # @return [String]
    attr_writer :report_file

    GRADLEW_NOT_FOUND = "Could not find `gradlew` inside current directory"
    REPORT_FILE_NOT_FOUND = "PMD report not found"

    # Calls PMD task of your Gradle project.
    # It fails if `gradlew` cannot be found inside current directory.
    # It fails if `report_file` cannot be found inside current directory.
    # @return [void]
    def report(inline_mode = true)
      return fail(GRADLEW_NOT_FOUND) unless gradlew_exists?

      exec_gradle_task
      return fail(REPORT_FILE_NOT_FOUND) unless report_file_exist?

      if inline_mode
        send_inline_comment
      end
    end

    # A getter for `gradle_module`, returning "app" if value is nil.
    # @return [String]
    def gradle_module
      @gradle_module ||= "app"
    end

    # A getter for `gradle_task`, returning "pmd" if value is nil.
    # @return [String]
    def gradle_task
      @gradle_task ||= "pmd"
    end

    # A getter for `report_file`, returning "app/build/reports/pmd/pmd.xml" if value is nil.
    # @return [String]
    def report_file
      @report_file ||= "app/build/reports/pmd/pmd.xml"
    end

    # A getter for current updated files
    # @return [Array[String]]
    def target_files
      @target_files ||= (git.modified_files - git.deleted_files) + git.added_files
    end

    # Run Gradle task
    # @return [void]
    def exec_gradle_task
      system "./gradlew #{gradle_task}"
    end

    # Check gradlew file exists in current directory
    # @return [Bool]
    def gradlew_exists?
      !`ls gradlew`.strip.empty?
    end

    # Check report_file exists in current directory
    # @return [Bool]
    def report_file_exist?
      File.exist?(report_file)
    end

    # A getter for `pmd_report`, returning PMD report.
    # @return [Oga::XML::Document]
    def pmd_report
      require "oga"
      @pmd_report ||= Oga.parse_xml(File.open(report_file))
    end

    # A getter for PMD issues, returning PMD issues.
    # @return [Array[PmdFile]]
    def pmd_issues
      @pmd_issues ||= pmd_report.xpath("//file").map do |pmd_file|
        PmdFile.new(gradle_module, pmd_file)
      end
    end

    # Send inline comment with Danger's warn or fail method
    # @return [void]
    def send_inline_comment
      pmd_issues.each do |pmd_file|
        next unless target_files.include? pmd_file.absolute_path

        pmd_file.violations.each do |pmd_violation|
          send(pmd_violation.type, pmd_violation.description, file: pmd_file.absolute_path, line: pmd_violation.line)
        end
      end
    end
  end
end
