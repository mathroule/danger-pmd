# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerPmd do
    it "should be a plugin" do
      expect(Danger::DangerPmd.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @pmd = @dangerfile.pmd
      end

      it "Check default report file path" do
        expect(@pmd.report_file).to eq("app/build/reports/pmd/pmd.xml")
      end

      it "Set custom report file path" do
        custom_report_path = "custom-path/pmd_sub_report.xml"
        @pmd.report_file = custom_report_path
        expect(@pmd.report_file).to eq(custom_report_path)
      end

      it "Check default report files paths" do
        expect(@pmd.report_files).to eq(["app/build/reports/pmd/pmd.xml"])
      end

      it "Set custom report files paths" do
        custom_report_paths = %w(custom-path/pmd_report_1.xml custom-path/pmd_report_2.xml)
        @pmd.report_files = custom_report_paths
        expect(@pmd.report_files).to eq(custom_report_paths)
      end

      it "Check default Gradle task" do
        expect(@pmd.gradle_task).to eq("pmd")
      end

      it "Set custom Gradle task" do
        custom_task = "pmdStagingDebug"
        @pmd.gradle_task = custom_task
        expect(@pmd.gradle_task).to eq(custom_task)
      end

      it "Skip Gradle task" do
        skip_gradle_task = true
        @pmd.skip_gradle_task = skip_gradle_task
        expect(@pmd.skip_gradle_task).to eq(skip_gradle_task)
      end

      it "Check default skip Gradle task" do
        expect(@pmd.skip_gradle_task).to eq(false)
      end

      it "Report with report file" do
        target_files = [
          "/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java",
          "/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java",
          "/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java",
          "/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_file = "spec/fixtures/pmd_report.xml"
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(4)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = pmd_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.absolute_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = pmd_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.absolute_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.violations).not_to be_nil
        expect(pmd_issue4.violations.length).to eq(2)
        expect(pmd_issue4.violations[0]).not_to be_nil
        expect(pmd_issue4.violations[0].line).to eq(12)
        expect(pmd_issue4.violations[0].description).to eq("The JUnit 4 test method name 'getLabel_1' doesn't match '[a-z][a-zA-Z0-9]*'")
        expect(pmd_issue4.violations[1]).not_to be_nil
        expect(pmd_issue4.violations[1].line).to eq(18)
        expect(pmd_issue4.violations[1].description).to eq("The JUnit 4 test method name 'getLabel_2' doesn't match '[a-z][a-zA-Z0-9]*'")
      end

      it "Report with report file not in target files" do
        target_files = [
          "/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java",
          "/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_file = "spec/fixtures/pmd_report.xml"
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(2)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue2.absolute_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(2)
        expect(pmd_issue2.violations[0]).not_to be_nil
        expect(pmd_issue2.violations[0].line).to eq(12)
        expect(pmd_issue2.violations[0].description).to eq("The JUnit 4 test method name 'getLabel_1' doesn't match '[a-z][a-zA-Z0-9]*'")
        expect(pmd_issue2.violations[1]).not_to be_nil
        expect(pmd_issue2.violations[1].line).to eq(18)
        expect(pmd_issue2.violations[1].description).to eq("The JUnit 4 test method name 'getLabel_2' doesn't match '[a-z][a-zA-Z0-9]*'")
      end

      it "Report with report files" do
        target_files = [
          "/Users/developer/sample/app/src/main/java/com/android/sample/Application.java",
          "/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java",
          "/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java",
          "/Users/developer/sample/app/src/main/java/com/android/sample/Utils.java",
          "/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java",
          "/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_files = %w(spec/fixtures/pmd_report.xml spec/fixtures/**/pmd_sub_report.xml)
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(6)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = pmd_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.absolute_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = pmd_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.absolute_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.violations).not_to be_nil
        expect(pmd_issue4.violations.length).to eq(2)
        expect(pmd_issue4.violations[0]).not_to be_nil
        expect(pmd_issue4.violations[0].line).to eq(12)
        expect(pmd_issue4.violations[0].description).to eq("The JUnit 4 test method name 'getLabel_1' doesn't match '[a-z][a-zA-Z0-9]*'")
        expect(pmd_issue4.violations[1]).not_to be_nil
        expect(pmd_issue4.violations[1].line).to eq(18)
        expect(pmd_issue4.violations[1].description).to eq("The JUnit 4 test method name 'getLabel_2' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue5 = pmd_issues[4]
        expect(pmd_issue5).not_to be_nil
        expect(pmd_issue5.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Application.java")
        expect(pmd_issue5.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Application.java")
        expect(pmd_issue5.violations).not_to be_nil
        expect(pmd_issue5.violations.length).to eq(1)
        expect(pmd_issue5.violations[0]).not_to be_nil
        expect(pmd_issue5.violations[0].line).to eq(135)
        expect(pmd_issue5.violations[0].description).to eq("The String literal \"label\" appears 5 times in this file; the first occurrence is on line 135")

        pmd_issue6 = pmd_issues[5]
        expect(pmd_issue6).not_to be_nil
        expect(pmd_issue6.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Utils.java")
        expect(pmd_issue6.absolute_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Utils.java")
        expect(pmd_issue6.violations).not_to be_nil
        expect(pmd_issue6.violations.length).to eq(2)
        expect(pmd_issue6.violations[0]).not_to be_nil
        expect(pmd_issue6.violations[0].line).to eq(23)
        expect(pmd_issue6.violations[0].description).to eq("These nested if statements could be combined")
        expect(pmd_issue6.violations[1]).not_to be_nil
        expect(pmd_issue6.violations[1].line).to eq(45)
        expect(pmd_issue6.violations[1].description).to eq("The String literal \"unused\" appears 4 times in this file; the first occurrence is on line 45")
      end
    end
  end
end
