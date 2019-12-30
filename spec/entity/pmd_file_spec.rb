# frozen_string_literal: true

require_relative "../spec_helper"

module Pmd
  require "oga"

  describe PmdFile do
    it "should initialize relative path ending with file separator" do
      xml = Oga.parse_xml(File.open("spec/fixtures/pmd_report.xml"))
      pmd_file = PmdFile.new("/Users/developer/sample/", xml.xpath("//file").first)

      expect(pmd_file.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.relative_path).to eq("app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.violations).not_to be_nil
      expect(pmd_file.violations.length).to eq(1)
      expect(pmd_file.violations.first).not_to be_nil
      expect(pmd_file.violations.first.line).to eq(5)
      expect(pmd_file.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")
    end

    it "should initialize relative path not ending with file separator" do
      xml = Oga.parse_xml(File.open("spec/fixtures/pmd_report.xml"))
      pmd_file = PmdFile.new("/Users/developer/sample", xml.xpath("//file").first)

      expect(pmd_file.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.relative_path).to eq("app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.violations).not_to be_nil
      expect(pmd_file.violations.length).to eq(1)
      expect(pmd_file.violations.first).not_to be_nil
      expect(pmd_file.violations.first.line).to eq(5)
      expect(pmd_file.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")
    end

    it "should initialize relative path not prefixed" do
      xml = Oga.parse_xml(File.open("spec/fixtures/pmd_report.xml"))
      pmd_file = PmdFile.new("/Users/developer/something", xml.xpath("//file").first)

      expect(pmd_file.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.relative_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.violations).not_to be_nil
      expect(pmd_file.violations.length).to eq(1)
      expect(pmd_file.violations.first).not_to be_nil
      expect(pmd_file.violations.first.line).to eq(5)
      expect(pmd_file.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")
    end
  end
end
