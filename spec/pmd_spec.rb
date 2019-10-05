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
        @my_plugin = @dangerfile.pmd
      end

      it "Check default report file path" do
        expect(@my_plugin.report_file).to eq("app/build/reports/pmd/pmd.xml")
      end

      it "Set custom report file path" do
        custom_report_path = "custom/pmd_report.xml"
        @my_plugin.report_file = custom_report_path
        expect(@my_plugin.report_file).to eq(custom_report_path)
      end

      it "Check default Gradle module" do
        expect(@my_plugin.gradle_module).to eq("app")
      end

      it "Set custom Gradle module" do
        my_module = "custom_module"
        @my_plugin.gradle_module = my_module
        expect(@my_plugin.gradle_module).to eq(my_module)
      end

      it "Check default Gradle task" do
        expect(@my_plugin.gradle_task).to eq("pmd")
      end

      it "Set custom Gradle task" do
        custom_task = "pmdStagingDebug"
        @my_plugin.gradle_task = custom_task
        expect(@my_plugin.gradle_task).to eq(custom_task)
      end

      it "Skip Gradle task" do
        skip_gradle_task = true
        @my_plugin.skip_gradle_task = skip_gradle_task
        expect(@my_plugin.skip_gradle_task).to eq(skip_gradle_task)
      end

      it "Check default skip Gradle task" do
        expect(@my_plugin.skip_gradle_task).to eq(false)
      end

      it "Create files" do
        custom_report_path = "spec/fixtures/pmd_report.xml"
        @my_plugin.report_file = custom_report_path
        pmd_issues = @my_plugin.pmd_issues
        expect(pmd_issues).not_to be_nil

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.absolute_path).to eq("app/src/main/java/com/android/sample/Tools.java")
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.source_path).to eq("/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.absolute_path).to eq("app/src/main/java/com/android/sample/MainActivity.java")
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = pmd_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.absolute_path).to eq("app/src/test/java/com/android/sample/ExampleUnitTest.java")
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = pmd_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.source_path).to eq("/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.absolute_path).to eq("app/src/test/java/com/android/sample/ToolsTest.java")
        expect(pmd_issue4.violations).not_to be_nil
        expect(pmd_issue4.violations.length).to eq(2)
        expect(pmd_issue4.violations[0]).not_to be_nil
        expect(pmd_issue4.violations[0].line).to eq(12)
        expect(pmd_issue4.violations[0].description).to eq("The JUnit 4 test method name 'getLabel_1' doesn't match '[a-z][a-zA-Z0-9]*'")
        expect(pmd_issue4.violations[1]).not_to be_nil
        expect(pmd_issue4.violations[1].line).to eq(18)
        expect(pmd_issue4.violations[1].description).to eq("The JUnit 4 test method name 'getLabel_2' doesn't match '[a-z][a-zA-Z0-9]*'")
      end

      it "Send inline comments" do
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return([])
        custom_report_path = "spec/fixtures/pmd_report.xml"
        @my_plugin.report_file = custom_report_path
        expect(@my_plugin.send_inline_comment).not_to be_nil
      end
    end
  end
end
