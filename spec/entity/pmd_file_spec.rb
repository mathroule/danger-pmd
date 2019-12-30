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
    end

    it "should initialize relative path not ending with file separator" do
      xml = Oga.parse_xml(File.open("spec/fixtures/pmd_report.xml"))
      pmd_file = PmdFile.new("/Users/developer/sample", xml.xpath("//file").first)

      expect(pmd_file.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.relative_path).to eq("app/src/main/java/com/android/sample/Tools.java")
    end

    it "should initialize relative path not prefixed" do
      xml = Oga.parse_xml(File.open("spec/fixtures/pmd_report.xml"))
      pmd_file = PmdFile.new("/Users/developer/something", xml.xpath("//file").first)

      expect(pmd_file.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
      expect(pmd_file.relative_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
    end
  end
end
