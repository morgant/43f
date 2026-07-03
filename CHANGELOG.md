# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* Added this CHANGELOG file with detailed documentation for all prior releases

### Changed

* Split license out of [README.md](README.md) into stand-alone
  [LICENSE](LICENSE) file
* Minor README & LICENSE formatting tweaks

### Fixed

* `43f`:
    * Silenced du(1)/df(1) errors for missing directories in `stats` command

## [0.3.0] - 2022-04-24

### Added

* Added command line & configuration file options for specifying file mode for
  repository & subdirectories

## [0.2.4] - 2020-10-13

### Fixed

* Fixed errors in validating days & months with leading zeros

## [0.2.3] - 2020-05-12

### Changed

* Minor refactor of verbose output

### Fixed

* Fixed potential function input validation issue

## [0.2.2] - 2020-04-19

### Fixed

* Fixed errors in `stats` command

## [0.2.1] - 2020-04-18

### Fixed

* Fixed bug causing monthly archives to be incorrectly moved to current month
  directory

## [0.2.0] - 2020-04-16

### Changed

* Improved functions input validation

### Fixed

* Don't create repository symlinks in dry-run mode or if repo isn't
  initialized
* Fix zero date offset calculations on OpenBSD
* Support long TLDs in `notify` lines in config file
* Fix too few days' data kept if previous month's length is less than days to
  keep

## [0.1.10] - 2019-11-20

### Fixed

* Fix for OpenBSD compatibility when consolidating files

## [0.1.9] - 2019-11-16

### Fixed

* Cross platform compatiblity improvements, esp. for OpenBSD

## [0.1.8] - 2015-01-02

### Fixed

* Fixed bug causing convenience symlinks to not correctly link to previous
  year directories during the first week of January

## [0.1.7] - 2014-01-22

### Fixed

* Fixed bug in Linux date parsing which failed for the month of October,
  causing issues similar to those fixed in v0.1.3

## [0.1.6] - 2014-01-16

### Fixed

* Fixed bug causing daily files to moved to month folders in current year
  instead of previous year when crossing year boundary within past 31 days
* Fixed bug preventing files from being consolidated in monthly folders from
  previous years

## [0.1.5] - 2014-01-16

### Fixed

* Automatically create new year directory on 1st of year

## [0.1.4] - 2013-10-29

### Fixed

* Fixed disk usage statistics calculation bugs

## [0.1.3] - 2013-10-09

### Fixed

* Fixed bug causing file consolidation to fail for files in an October month
  folder
* Fixed possible issues moving daily files to month folder when day was >= `8`

## [0.1.2] - 2013-08-08

### Fixed

* Fixed bug causing fatal error when moving files to month folder when
  destination month was >= `8`

## [0.1.1] - 2013-06-17

### Added

* Added optional year parameter to `init` command
* Linux support

### Fixed

* Fixed bug causing old files to be moved to incorrect month folder on the 1st
  day of a month
* Files outside the number of months to keep are now rolled properly
* Fix in launchd.plist

## [0.1.0] - 2009-03-07

### Added

* Initial Development

[unreleased]: https://github.com/morgant/43f/compare/0.3...main
[0.3.0]: https://github.com/morgant/43f/compare/0.2.4...0.3
[0.2.4]: https://github.com/morgant/43f/compare/0.2.3...0.2.4
[0.2.3]: https://github.com/morgant/43f/compare/0.2.2...0.2.3
[0.2.2]: https://github.com/morgant/43f/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/morgant/43f/compare/0.2...0.2.1
[0.2.0]: https://github.com/morgant/43f/compare/0.1.10...0.2
[0.1.10]: https://github.com/morgant/43f/compare/0.1.9...0.1.10
[0.1.9]: https://github.com/morgant/43f/compare/0.1.8...0.1.9
[0.1.8]: https://github.com/morgant/43f/compare/0.1.7...0.1.8
[0.1.7]: https://github.com/morgant/43f/compare/0.1.6...0.1.7
[0.1.6]: https://github.com/morgant/43f/compare/0.1.5...0.1.6
[0.1.5]: https://github.com/morgant/43f/compare/0.1.4...0.1.5
[0.1.4]: https://github.com/morgant/43f/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/morgant/43f/compare/0.1.3...0.1.3
[0.1.2]: https://github.com/morgant/43f/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/morgant/43f/compare/0.1...0.1.1
[0.1.0]: https://github.com/morgant/43f/releases/tag/0.1
