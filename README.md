# Danger PMD

Danger plugin for PMD formatted xml file. This plugin is inspired from https://github.com/kazy1991/danger-findbugs.

## Installation

    $ gem install danger-pmd

## Usage

    Methods and attributes from this plugin are available in
    your `Dangerfile` under the `pmd` namespace.

<blockquote>Running PMD with its basic configuration
<pre>
pmd.report
</pre>
</blockquote>

<blockquote>Running PMD with a specific Gradle task or report_file
<pre>
pmd.gradle_task = 'app:pmd' #defalut: pmd
pmd.report_file = "app/build/reports/pmd/pmd.xml"
pmd.report
</pre>
</blockquote>

#### Attributes

`gradle_module` - Custom Gradle module to run.
This is useful when your project has different flavors.
Defaults to "app".

`gradle_task` - Custom Gradle task to run.
This is useful when your project has different flavors.
Defaults to "pmd".

`report_file` - Location of report file
If your pmd task outputs to a different location, you can specify it here.
Defaults to "app/build/reports/pmd/pmd.xml".

#### Methods

`report` - Calls pmd task of your Gradle project.
It fails if `gradlew` cannot be found inside current directory.
It fails if `report_file` cannot be found inside current directory.

`target_files` - A getter for current updated files

`exec_gradle_task` - Run Gradle task

`gradlew_exists?` - Check gradlew file exists in current directory

`report_file_exist?` - Check report_file exists in current directory

`pmd_report` - A getter for `pmd_report`, returning PMD report.

`pmd_issues` - A getter for PMD issues, returning PMD issues.

`send_inline_comment` - Send inline comment with danger's warn or fail method

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
