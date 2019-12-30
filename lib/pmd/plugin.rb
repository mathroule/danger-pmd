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
  # @example Running PMD with a specific Gradle task or report file (glob accepted)
  #
  #          pmd.gradle_task = 'app:pmd' #defalut: pmd
  #          pmd.report_file = "module/build/reports/pmd/pmd.xml" #defalut: app/build/reports/pmd/pmd.xml
  #          pmd.report
  #
  # @example Running PMD with a specific root path
  #
  #          pmd.root_path = '/Users/developer/project
  #          pmd.report
  #
  # @example Running PMD with an array of report files (glob accepted)
  #
  #          pmd.report_files = ["modules/**/build/reports/pmd/pmd.xml", "app/build/reports/pmd/pmd.xml"]
  #          pmd.report
  #
  # @example Running PMD without running a Gradle task
  #
  #          pmd.skip_gradle_task = true
  #          pmd.report
  #
  # @see mathroule/danger-pmd
  # @tags java, android, pmd

  class DangerPmd < Plugin
    require_relative "./entity/pmd_file"

    # Custom Gradle task to run.
    # This is useful when your project has different flavors.
    # Defaults to "pmd".
    # @return [String]
    attr_writer :gradle_task

    # A getter for `gradle_task`, returning "pmd" if value is nil.
    # @return [String]
    def gradle_task
      @gradle_task ||= "pmd"
    end

    # Skip Gradle task.
    # If you skip Gradle task, for example project does not manage Gradle.
    # Defaults to `false`.
    # @return [Bool]
    attr_writer :skip_gradle_task

    # A getter for `skip_gradle_task`, returning false if value is nil.
    # @return [Boolean]
    def skip_gradle_task
      @skip_gradle_task ||= false
    end

    # An absolute path to a root.
    # To comment errors to VCS, this needs to know relative path of files from the root.
    # Defaults to result of "git rev-parse --show-toplevel".
    # @return [String] the root path of git repository by default.
    attr_writer :root_path

    # A getter for `root_path`, returning result of "git rev-parse --show-toplevel" if value is nil.
    # @return [String]
    def root_path
      @root_path ||= `git rev-parse --show-toplevel`.chomp
    end

    # Location of report file.
    # If your pmd task outputs to a different location, you can specify it here.
    # Defaults to "app/build/reports/pmd/pmd.xml".
    # @return [String]
    attr_writer :report_file

    # A getter for `report_file`, returning "app/build/reports/pmd/pmd.xml" if value is nil.
    # @return [String]
    def report_file
      @report_file ||= "app/build/reports/pmd/pmd.xml"
    end

    # Location of report files.
    # If your pmd task outputs to a different location, you can specify it here.
    # Defaults to ["app/build/reports/pmd/pmd.xml"].
    # @return [Array[String]]
    attr_writer :report_files

    # A getter for `report_files`, returning ["app/build/reports/pmd/pmd.xml"] if value is nil.
    # @return [Array[String]]
    def report_files
      @report_files ||= [report_file]
    end

    # Calls PMD task of your Gradle project.
    # It fails if `gradlew` cannot be found inside current directory.
    # It fails if `report_file` cannot be found inside current directory.
    # It fails if `report_files` is empty.
    # @return [Array[PmdFile]]
    def report(inline_mode = true)
      unless skip_gradle_task
        return fail("Could not find `gradlew` inside current directory") unless gradlew_exists?

        exec_gradle_task
      end

      report_files_expanded = Dir.glob(report_files).sort
      return fail("Could not find matching PMD report files for #{report_files} inside current directory") if report_files_expanded.empty?

      do_comment(report_files_expanded, inline_mode)
    end

    private

    # Check gradlew file exists in current directory.
    # @return [Bool]
    def gradlew_exists?
      !`ls gradlew`.strip.empty?
    end

    # Run Gradle task.
    # @return [void]
    def exec_gradle_task
      system "./gradlew #{gradle_task}"
    end

    # Check report_file exists in current directory.
    # @return [Bool]
    def report_file_exist?(report_file)
      File.exist?(report_file)
    end

    # A getter for `pmd_report`, returning PMD report.
    # @return [Oga::XML::Document]
    def pmd_report(report_file)
      require "oga"
      Oga.parse_xml(File.open(report_file))
    end

    # A getter for PMD issues, returning PMD issues.
    # @return [Array[PmdFile]]
    def pmd_issues(report_file)
      pmd_report(report_file).xpath("//file").map do |pmd_file|
        PmdFile.new(root_path, pmd_file)
      end
    end

    # A getter for current updated files.
    # @return [Array[String]]
    def target_files
      @target_files ||= (git.modified_files - git.deleted_files) + git.added_files
    end

    # Generate report and send inline comment with Danger's warn or fail method.
    # @return [Array[PmdFile]]
    def do_comment(report_files, inline_mode = true)
      pmd_issues = []

      report_files.each do |report_file|
        pmd_issues(report_file).each do |pmd_file|
          next unless target_files.include? pmd_file.relative_path

          pmd_issues.push(pmd_file)

          pmd_file.violations.each do |pmd_violation|
            if inline_mode
              send(pmd_violation.type, pmd_violation.description, file: pmd_file.relative_path, line: pmd_violation.line)
            else
              send(pmd_violation.type, "#{pmd_file.relative_path} : #{pmd_violation.description} at #{pmd_violation.line}")
            end
          end
        end
      end

      pmd_issues
    end
  end
end
