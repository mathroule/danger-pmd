# Danger PMD

Checks on your Gradle project's Java source files.
This is done using [PMD](https://pmd.github.io)
Results are passed out as tables in markdown.

This plugin is inspired from https://github.com/kazy1991/danger-findbugs.

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

<blockquote>Running PMD with a specific Gradle task or report file (glob accepted)
  <pre>
pmd.gradle_task = 'app:pmd' # default: pmd
pmd.report_file = 'module/build/reports/pmd/pmd.xml' # default: app/build/reports/pmd/pmd.xml
pmd.report
  </pre>
</blockquote>

<blockquote>Running PMD with a specific root path
  <pre>
pmd.root_path = '/Users/developer/project'
pmd.report
  </pre>
</blockquote>

<blockquote>Running PMD with an array of report files (glob accepted)
  <pre>
pmd.report_files = ['modules/**/build/reports/pmd/pmd.xml', 'app/build/reports/pmd/pmd.xml']
pmd.report
  </pre>
</blockquote>

<blockquote>Running PMD without running a Gradle task
  <pre>
pmd.skip_gradle_task = true
pmd.report
  </pre>
</blockquote>

#### Attributes

`gradle_task` - Custom Gradle task to run.
This is useful when your project has different flavors.
Defaults to "pmd".

`skip_gradle_task` - Skip Gradle task.
If you skip Gradle task, for example project does not manage Gradle.
Defaults to `false`.

`root_path` - An absolute path to a root.
To comment errors to VCS, this needs to know relative path of files from the root.
Defaults to result of "git rev-parse --show-toplevel".

`report_file` - Location of report file.
If your pmd task outputs to a different location, you can specify it here.
Defaults to "app/build/reports/pmd/pmd.xml".

`report_files` - Location of report files.
If your pmd task outputs to a different location, you can specify it here.
Defaults to ['app/build/reports/pmd/pmd.xml'].

#### Methods

`report` - Calls PMD task of your Gradle project.
It fails if `gradlew` cannot be found inside current directory.
It fails if `report_file` cannot be found inside current directory.
It fails if `report_files` is empty.

`gradle_task` - A getter for `gradle_task`, returning Gradle task report.

`skip_gradle_task` - A getter for `skip_gradle_task`.

`root_path` - A getter for `root_path`.

`report_file` - A getter for `report_file`.

`report_files` - A getter for `report_files`.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
