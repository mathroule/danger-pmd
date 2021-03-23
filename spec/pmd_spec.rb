# frozen_string_literal: true

require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerPmd do
    it 'should be a plugin' do
      expect(Danger::DangerPmd.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @pmd = @dangerfile.pmd
      end

      it 'Check default Gradle task' do
        expect(@pmd.gradle_task).to eq('pmd')
      end

      it 'Set custom Gradle task' do
        @pmd.gradle_task = 'pmdStagingDebug'
        expect(@pmd.gradle_task).to eq('pmdStagingDebug')
      end

      it 'Check default skip Gradle task' do
        expect(@pmd.skip_gradle_task).to be_falsey
      end

      it 'Set custom skip Gradle task' do
        @pmd.skip_gradle_task = true
        expect(@pmd.skip_gradle_task).to be_truthy
      end

      it 'Check default report file path' do
        expect(@pmd.report_file).to eq('app/build/reports/pmd/pmd.xml')
      end

      it 'Set custom report file path' do
        @pmd.report_file = 'custom-path/pmd_sub_report.xml'
        expect(@pmd.report_file).to eq('custom-path/pmd_sub_report.xml')
      end

      it 'Check default report files paths' do
        expect(@pmd.report_files).to contain_exactly('app/build/reports/pmd/pmd.xml')
      end

      it 'Set custom report files paths' do
        @pmd.report_files = %w[custom-path/pmd_report_1.xml custom-path/pmd_report_2.xml]
        expect(@pmd.report_files).to contain_exactly('custom-path/pmd_report_1.xml', 'custom-path/pmd_report_2.xml')
      end

      it 'Check default root path' do
        expect(@pmd.root_path).to eq(Dir.pwd)
      end

      it 'Set custom root path' do
        @pmd.root_path = '/Users/developer/sample/'
        expect(@pmd.root_path).to eq('/Users/developer/sample/')
      end

      it 'Report with report file' do
        # noinspection RubyLiteralArrayInspection
        target_files = [
          "app/src/main/java/com/android/sample/MainActivity.java",
          "app/src/main/java/com/android/sample/Tools.java",
          "app/src/test/java/com/android/sample/ExampleUnitTest.java",
          "app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_file = 'spec/fixtures/pmd_report.xml'
        @pmd.root_path = '/Users/developer/sample/'
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(4)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.relative_path).to eq('app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.relative_path).to eq('app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = pmd_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.relative_path).to eq('app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = pmd_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java')
        expect(pmd_issue4.relative_path).to eq('app/src/test/java/com/android/sample/ToolsTest.java')
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
        # noinspection RubyLiteralArrayInspection
        target_files = [
          "app/src/main/java/com/android/sample/Tools.java",
          "app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_file = "spec/fixtures/pmd_report.xml"
        @pmd.root_path = "/Users/developer/sample/"
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(2)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.relative_path).to eq('app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java')
        expect(pmd_issue2.relative_path).to eq('app/src/test/java/com/android/sample/ToolsTest.java')
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
        # noinspection RubyLiteralArrayInspection
        target_files = [
          "app/src/main/java/com/android/sample/Application.java",
          "app/src/main/java/com/android/sample/MainActivity.java",
          "app/src/main/java/com/android/sample/Tools.java",
          "app/src/main/java/com/android/sample/Utils.java",
          "app/src/test/java/com/android/sample/ExampleUnitTest.java",
          "app/src/test/java/com/android/sample/ToolsTest.java"
        ]
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return(target_files)

        @pmd.report_files = %w[spec/fixtures/pmd_report.xml spec/fixtures/**/pmd_sub_report.xml]
        @pmd.root_path = '/Users/developer/sample/'
        @pmd.skip_gradle_task = true

        pmd_issues = @pmd.report
        expect(pmd_issues).not_to be_nil
        expect(pmd_issues.length).to be(6)

        pmd_issue1 = pmd_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.relative_path).to eq('app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = pmd_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.relative_path).to eq('app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = pmd_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.relative_path).to eq('app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = pmd_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java')
        expect(pmd_issue4.relative_path).to eq('app/src/test/java/com/android/sample/ToolsTest.java')
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
        expect(pmd_issue5.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Utils.java')
        expect(pmd_issue5.relative_path).to eq('app/src/main/java/com/android/sample/Utils.java')
        expect(pmd_issue5.violations).not_to be_nil
        expect(pmd_issue5.violations.length).to eq(2)
        expect(pmd_issue5.violations[0]).not_to be_nil
        expect(pmd_issue5.violations[0].line).to eq(23)
        expect(pmd_issue5.violations[0].description).to eq('These nested if statements could be combined')
        expect(pmd_issue5.violations[1]).not_to be_nil
        expect(pmd_issue5.violations[1].line).to eq(45)
        expect(pmd_issue5.violations[1].description).to eq('The String literal "unused" appears 4 times in this file; the first occurrence is on line 45')

        pmd_issue6 = pmd_issues[5]
        expect(pmd_issue6).not_to be_nil
        expect(pmd_issue6.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Application.java')
        expect(pmd_issue6.relative_path).to eq('app/src/main/java/com/android/sample/Application.java')
        expect(pmd_issue6.violations).not_to be_nil
        expect(pmd_issue6.violations.length).to eq(1)
        expect(pmd_issue6.violations[0]).not_to be_nil
        expect(pmd_issue6.violations[0].line).to eq(135)
        expect(pmd_issue6.violations[0].description).to eq('The String literal "label" appears 5 times in this file; the first occurrence is on line 135')
      end

      it 'Report without Gradle' do
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return([])

        @pmd.report_file = 'spec/fixtures/pmd_report.xml'
        @pmd.skip_gradle_task = false

        expect { @pmd.report }.to raise_error('Could not find `gradlew` inside current directory')
      end

      it 'Report without existing report file' do
        allow_any_instance_of(Danger::DangerPmd).to receive(:target_files).and_return([])

        @pmd.report_file = 'spec/fixtures/custom/pmd_report.xml'
        @pmd.skip_gradle_task = true

        expect { @pmd.report }.to raise_error('Could not find matching PMD report files for ["spec/fixtures/custom/pmd_report.xml"] inside current directory')
      end
    end
  end
end
