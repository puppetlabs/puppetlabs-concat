<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v9.1.0) - 2024-12-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v9.0.2...v9.1.0)

### Added

- (CAT-2119) Add Ubuntu 24.04 support [#817](https://github.com/puppetlabs/puppetlabs-concat/pull/817) ([shubhamshinde360](https://github.com/shubhamshinde360))
- (CAT-2100) Add Debian 12 support [#815](https://github.com/puppetlabs/puppetlabs-concat/pull/815) ([shubhamshinde360](https://github.com/shubhamshinde360))

### Fixed

- (CAT-2158) Upgrade rexml to address CVE-2024-49761 [#819](https://github.com/puppetlabs/puppetlabs-concat/pull/819) ([amitkarsale](https://github.com/amitkarsale))

## [v9.0.2](https://github.com/puppetlabs/puppetlabs-concat/tree/v9.0.2) - 2024-01-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v9.0.1...v9.0.2)

### Fixed

- (CAT-1692) - Compatibility fix with puppet 7.14 [#804](https://github.com/puppetlabs/puppetlabs-concat/pull/804) ([Ramesh7](https://github.com/Ramesh7))

## [v9.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/v9.0.1) - 2023-11-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v9.0.0...v9.0.1)

### Fixed

- #775 - Explicitly resolve deferred values [#789](https://github.com/puppetlabs/puppetlabs-concat/pull/789) ([fetzerms](https://github.com/fetzerms))

## [v9.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v9.0.0) - 2023-06-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v8.0.1...v9.0.0)

### Changed

- pdksync - (MAINT) - Require Stdlib 9.x [#783](https://github.com/puppetlabs/puppetlabs-concat/pull/783) ([LukasAud](https://github.com/LukasAud))

## [v8.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/v8.0.1) - 2023-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v8.0.0...v8.0.1)

### Fixed

- Revert "Correct Naming/AccessorMethodName" [#777](https://github.com/puppetlabs/puppetlabs-concat/pull/777) ([alexjfisher](https://github.com/alexjfisher))
- (MAINT) Addressing wrong Rubocop TargetRubyVersion [#776](https://github.com/puppetlabs/puppetlabs-concat/pull/776) ([LukasAud](https://github.com/LukasAud))
- (CONT-891) Address nightly rubocop failures [#774](https://github.com/puppetlabs/puppetlabs-concat/pull/774) ([LukasAud](https://github.com/LukasAud))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v8.0.0) - 2023-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.4.0...v8.0.0)

### Changed

- (CONT-775) Puppet 8 support / Drop Puppet 6 support [#768](https://github.com/puppetlabs/puppetlabs-concat/pull/768) ([LukasAud](https://github.com/LukasAud))

## [v7.4.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.4.0) - 2023-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.3.3...v7.4.0)

### Added

- Add parameter to not create empty files when no fragments are defined [#766](https://github.com/puppetlabs/puppetlabs-concat/pull/766) ([JonasVerhofste](https://github.com/JonasVerhofste))

### Fixed

- puppet5: drop remnants of puppet5 code [#761](https://github.com/puppetlabs/puppetlabs-concat/pull/761) ([b4ldr](https://github.com/b4ldr))
- Allow content parameter of concat_fragment to be Sensitive [#757](https://github.com/puppetlabs/puppetlabs-concat/pull/757) ([baurmatt](https://github.com/baurmatt))

## [v7.3.3](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.3.3) - 2023-03-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.3.2...v7.3.3)

### Fixed

- Revert "(MODULES-3522) Removing redundant 'requires'" [#759](https://github.com/puppetlabs/puppetlabs-concat/pull/759) ([LukasAud](https://github.com/LukasAud))

## [v7.3.2](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.3.2) - 2023-03-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.3.1...v7.3.2)

### Fixed

- (MODULES-3522) Removing redundant 'requires' [#755](https://github.com/puppetlabs/puppetlabs-concat/pull/755) ([LukasAud](https://github.com/LukasAud))

## [v7.3.1](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.3.1) - 2023-02-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.3.0...v7.3.1)

### Fixed

- pdksync - (CONT-189) Remove support for RedHat6 / OracleLinux6 / Scientific6 [#747](https://github.com/puppetlabs/puppetlabs-concat/pull/747) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) Dropping Support for Debian 9 [#744](https://github.com/puppetlabs/puppetlabs-concat/pull/744) ([jordanbreen28](https://github.com/jordanbreen28))

## [v7.3.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.3.0) - 2022-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.2.0...v7.3.0)

### Added

- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#739](https://github.com/puppetlabs/puppetlabs-concat/pull/739) ([david22swan](https://github.com/david22swan))
- (GH-cat-12) Add Support for Redhat 9 [#738](https://github.com/puppetlabs/puppetlabs-concat/pull/738) ([david22swan](https://github.com/david22swan))

### Fixed

- (MAINT) Drop support for Solaris 10, Windows (7, 8.1), Windows Server 2008 R2 and AIX (5.3, 6.1) [#741](https://github.com/puppetlabs/puppetlabs-concat/pull/741) ([jordanbreen28](https://github.com/jordanbreen28))

## [v7.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.2.0) - 2022-05-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.1.1...v7.2.0)

### Added

- pdksync - (FM-8922) - Add Support for Windows 2022 [#725](https://github.com/puppetlabs/puppetlabs-concat/pull/725) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#720](https://github.com/puppetlabs/puppetlabs-concat/pull/720) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1751) - Add Support for Rocky 8 [#719](https://github.com/puppetlabs/puppetlabs-concat/pull/719) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - (GH-iac-334) Remove Support for Ubuntu 14.04 [#729](https://github.com/puppetlabs/puppetlabs-concat/pull/729) ([david22swan](https://github.com/david22swan))
- pdksync - (GH-iac-334) Remove Support for Ubuntu 16.04 [#728](https://github.com/puppetlabs/puppetlabs-concat/pull/728) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1787) Remove Support for CentOS 6 [#723](https://github.com/puppetlabs/puppetlabs-concat/pull/723) ([david22swan](https://github.com/david22swan))
- pdksync - (IAC-1598) - Remove Support for Debian 8 [#718](https://github.com/puppetlabs/puppetlabs-concat/pull/718) ([david22swan](https://github.com/david22swan))

## [v7.1.1](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.1.1) - 2021-08-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.1.0...v7.1.1)

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.1.0) - 2021-08-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.0.2...v7.1.0)

### Added

- pdksync - (IAC-1709) - Add Support for Debian 11 [#713](https://github.com/puppetlabs/puppetlabs-concat/pull/713) ([david22swan](https://github.com/david22swan))

## [v7.0.2](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.0.2) - 2021-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.0.1...v7.0.2)

### Fixed

- fix merge nil hashes [#708](https://github.com/puppetlabs/puppetlabs-concat/pull/708) ([thde](https://github.com/thde))
- Do not modify metaparams in place [#705](https://github.com/puppetlabs/puppetlabs-concat/pull/705) ([ekohl](https://github.com/ekohl))

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.0.1) - 2021-03-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v7.0.0...v7.0.1)

### Fixed

- (IAC-1497) remove unsupported `translate` dependency [#693](https://github.com/puppetlabs/puppetlabs-concat/pull/693) ([DavidS](https://github.com/DavidS))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v7.0.0) - 2021-03-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v6.4.0...v7.0.0)

### Changed

- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#685](https://github.com/puppetlabs/puppetlabs-concat/pull/685) ([carabasdaniel](https://github.com/carabasdaniel))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v6.4.0) - 2020-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v6.3.0...v6.4.0)

### Added

- pdksync - (feat) Add support for Puppet 7 [#672](https://github.com/puppetlabs/puppetlabs-concat/pull/672) ([daianamezdrea](https://github.com/daianamezdrea))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v6.3.0) - 2020-11-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v6.2.0...v6.3.0)

### Added

- (IAC-746) - Add ubuntu 20.04 support [#644](https://github.com/puppetlabs/puppetlabs-concat/pull/644) ([david22swan](https://github.com/david22swan))
- Add support for Deferred function in concat fragment [#627](https://github.com/puppetlabs/puppetlabs-concat/pull/627) ([baurmatt](https://github.com/baurmatt))

### Fixed

- (MODULES-9711) Consistently manage concat with no fragments [#661](https://github.com/puppetlabs/puppetlabs-concat/pull/661) ([seanmil](https://github.com/seanmil))
- (IAC-981) - Removal of inappropriate terminology [#659](https://github.com/puppetlabs/puppetlabs-concat/pull/659) ([david22swan](https://github.com/david22swan))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v6.2.0) - 2020-01-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v6.1.0...v6.2.0)

### Added

- pdksync - (FM-8581) - Debian 10 added to travis and provision file refactored [#624](https://github.com/puppetlabs/puppetlabs-concat/pull/624) ([david22swan](https://github.com/david22swan))
- (FM-8698) - Addition of Support for CentOS 8 [#615](https://github.com/puppetlabs/puppetlabs-concat/pull/615) ([david22swan](https://github.com/david22swan))
- FM-8398 - support Debian10 [#599](https://github.com/puppetlabs/puppetlabs-concat/pull/599) ([lionce](https://github.com/lionce))

### Fixed

- Fix newline handling at the end of fragments [#623](https://github.com/puppetlabs/puppetlabs-concat/pull/623) ([LadyNamedLaura](https://github.com/LadyNamedLaura))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v6.1.0) - 2019-07-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/v6.0.0...v6.1.0)

### Added

- FM-8049 - add redhat8 support [#584](https://github.com/puppetlabs/puppetlabs-concat/pull/584) ([lionce](https://github.com/lionce))

### Fixed

- (MODULES-9479) Fix nested array merge behavior [#593](https://github.com/puppetlabs/puppetlabs-concat/pull/593) ([seanmil](https://github.com/seanmil))
- (FM-8317) Updated regex to allow for windows paths with \'s [#591](https://github.com/puppetlabs/puppetlabs-concat/pull/591) ([pgrant87](https://github.com/pgrant87))
- (bugfix) allow private keys in ssh testing [#585](https://github.com/puppetlabs/puppetlabs-concat/pull/585) ([tphoney](https://github.com/tphoney))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/v6.0.0) - 2019-05-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/5.3.0...v6.0.0)

### Changed

- pdksync - (MODULES-8444) - Raise lower Puppet bound [#575](https://github.com/puppetlabs/puppetlabs-concat/pull/575) ([david22swan](https://github.com/david22swan))

### Added

- (FM-7606) enable litmus for concat [#577](https://github.com/puppetlabs/puppetlabs-concat/pull/577) ([tphoney](https://github.com/tphoney))

### Fixed

- (FM-8073) litmus block support [#580](https://github.com/puppetlabs/puppetlabs-concat/pull/580) ([tphoney](https://github.com/tphoney))

## [5.3.0](https://github.com/puppetlabs/puppetlabs-concat/tree/5.3.0) - 2019-02-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/5.2.0...5.3.0)

### Added

- (MODULES-8138) - Addition of support for SLES 15 [#545](https://github.com/puppetlabs/puppetlabs-concat/pull/545) ([david22swan](https://github.com/david22swan))

### Fixed

- (FM-7725) - Remove OSX testing/support for concat [#561](https://github.com/puppetlabs/puppetlabs-concat/pull/561) ([lionce](https://github.com/lionce))
- pdksync - (FM-7655) Fix rubygems-update for ruby < 2.3 [#550](https://github.com/puppetlabs/puppetlabs-concat/pull/550) ([tphoney](https://github.com/tphoney))

## [5.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/5.2.0) - 2018-12-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/5.1.0...5.2.0)

### Added

- (FM-7339) - Add i18n implementation [#537](https://github.com/puppetlabs/puppetlabs-concat/pull/537) ([eimlav](https://github.com/eimlav))
- (FM-7341) - Added REFERENCE.md and updated documentation [#536](https://github.com/puppetlabs/puppetlabs-concat/pull/536) ([eimlav](https://github.com/eimlav))
- (MODULES-5124) Add support for JSON arrays [#519](https://github.com/puppetlabs/puppetlabs-concat/pull/519) ([johanfleury](https://github.com/johanfleury))

### Fixed

- (FM-7581) - Fix CI failures for Windows 2016 and 10 Enterprise [#540](https://github.com/puppetlabs/puppetlabs-concat/pull/540) ([eimlav](https://github.com/eimlav))
- (MODULES-8287) - Fix fomat=>'yaml' allowing only hashes [#535](https://github.com/puppetlabs/puppetlabs-concat/pull/535) ([eimlav](https://github.com/eimlav))
-  (FM-7513) - Removing Windows 2016-core from our support matrix  [#534](https://github.com/puppetlabs/puppetlabs-concat/pull/534) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-8088) - newline_spec.rb test expectation update [#531](https://github.com/puppetlabs/puppetlabs-concat/pull/531) ([lionce](https://github.com/lionce))
- (MODULES-7717) ensure_newline uses unix line ending on windows [#517](https://github.com/puppetlabs/puppetlabs-concat/pull/517) ([tkishel](https://github.com/tkishel))

## [5.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/5.1.0) - 2018-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/5.0.0...5.1.0)

### Added

- pdksync - (FM-7392) - Puppet 6 Testing Changes [#525](https://github.com/puppetlabs/puppetlabs-concat/pull/525) ([pmcmaw](https://github.com/pmcmaw))
- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#524](https://github.com/puppetlabs/puppetlabs-concat/pull/524) ([tphoney](https://github.com/tphoney))
- pdksync - (MODULES-7658) use beaker4 in puppet-module-gems [#518](https://github.com/puppetlabs/puppetlabs-concat/pull/518) ([tphoney](https://github.com/tphoney))

## [5.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/5.0.0) - 2018-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.2.1...5.0.0)

### Changed

- [FM-6954] Removal of scientific linux 5 and debian 7 [#508](https://github.com/puppetlabs/puppetlabs-concat/pull/508) ([david22swan](https://github.com/david22swan))

### Added

- (FM-7206) Update concat to support Ubuntu 18.04 [#510](https://github.com/puppetlabs/puppetlabs-concat/pull/510) ([david22swan](https://github.com/david22swan))

## [4.2.1](https://github.com/puppetlabs/puppetlabs-concat/tree/4.2.1) - 2018-03-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.2.0...4.2.1)

### Fixed

- Handle concat_file source when not an array [#493](https://github.com/puppetlabs/puppetlabs-concat/pull/493) ([vicinus](https://github.com/vicinus))
- (MODULES-6817) noop => false for concat_file [#492](https://github.com/puppetlabs/puppetlabs-concat/pull/492) ([hunner](https://github.com/hunner))

## [4.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/4.2.0) - 2018-02-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.1.1...4.2.0)

### Fixed

- Revert "Refactor fragment sorting" [#488](https://github.com/puppetlabs/puppetlabs-concat/pull/488) ([pmcmaw](https://github.com/pmcmaw))

## [4.1.1](https://github.com/puppetlabs/puppetlabs-concat/tree/4.1.1) - 2017-11-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.1.0...4.1.1)

### Changed

- Cleanup ruby code via rubocop [#473](https://github.com/puppetlabs/puppetlabs-concat/pull/473) ([willmeek](https://github.com/willmeek))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/4.1.0) - 2017-10-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.0.1...4.1.0)

### Added

- tdevelioglu/refurbish [#428](https://github.com/puppetlabs/puppetlabs-concat/pull/428) ([tdevelioglu](https://github.com/tdevelioglu))

### Fixed

- Format force tests [#469](https://github.com/puppetlabs/puppetlabs-concat/pull/469) ([willmeek](https://github.com/willmeek))
- is_string is deprecated. Please use puppet language [#458](https://github.com/puppetlabs/puppetlabs-concat/pull/458) ([tritrimax](https://github.com/tritrimax))

## [4.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/4.0.1) - 2017-06-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/4.0.0...4.0.1)

## [4.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/4.0.0) - 2017-04-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/3.0.0...4.0.0)

## [3.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/3.0.0) - 2017-04-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/2.2.1...3.0.0)

### Changed

- (MODULES-4264) Update for puppet 4 data types [#437](https://github.com/puppetlabs/puppetlabs-concat/pull/437) ([hunner](https://github.com/hunner))

### Added

- Implement beaker-module_install_helper and cleanup spec_helper_acceptance.rb [#426](https://github.com/puppetlabs/puppetlabs-concat/pull/426) ([wilson208](https://github.com/wilson208))

## [2.2.1](https://github.com/puppetlabs/puppetlabs-concat/tree/2.2.1) - 2017-04-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/2.2.0...2.2.1)

### Added

- (FM-5972) gettext and spec.opts [#422](https://github.com/puppetlabs/puppetlabs-concat/pull/422) ([eputnam](https://github.com/eputnam))

### Fixed

- Four commits [#433](https://github.com/puppetlabs/puppetlabs-concat/pull/433) ([hunner](https://github.com/hunner))
- (MODULES-4474) Drop autorequire of fragments in concat_file [#430](https://github.com/puppetlabs/puppetlabs-concat/pull/430) ([tdevelioglu](https://github.com/tdevelioglu))
- Invalid tag fix [#429](https://github.com/puppetlabs/puppetlabs-concat/pull/429) ([fuero](https://github.com/fuero))

## [2.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/2.2.0) - 2016-06-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/2.1.0...2.2.0)

### Changed

- Fix the minimum required stdlib version to 4.2.0. [#386](https://github.com/puppetlabs/puppetlabs-concat/pull/386) ([parabolala](https://github.com/parabolala))

### Added

- MODULES-3156: propagate the validate_cmd to the file resource [#394](https://github.com/puppetlabs/puppetlabs-concat/pull/394) ([vicinus](https://github.com/vicinus))

### Fixed

- (MODULES-3463) Properly passes metaparams to generated resource [#402](https://github.com/puppetlabs/puppetlabs-concat/pull/402) ([bmjen](https://github.com/bmjen))
- (MODULES-3332) Correct target validation [#400](https://github.com/puppetlabs/puppetlabs-concat/pull/400) ([hdeheer](https://github.com/hdeheer))
- (MODULES-3332 ) Correct the path validation. [#397](https://github.com/puppetlabs/puppetlabs-concat/pull/397) ([binford2k](https://github.com/binford2k))
- (MODULES-3097) fix fragment sorting [#391](https://github.com/puppetlabs/puppetlabs-concat/pull/391) ([rettier](https://github.com/rettier))
- Fix helper on host command [#389](https://github.com/puppetlabs/puppetlabs-concat/pull/389) ([hunner](https://github.com/hunner))
- (MODULES-3027) Fixes escaping the '*' character in tag creation. [#387](https://github.com/puppetlabs/puppetlabs-concat/pull/387) ([bmjen](https://github.com/bmjen))

## [2.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/2.1.0) - 2016-01-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.5...2.1.0)

### Fixed

- Fixes missing directory environment failure [#381](https://github.com/puppetlabs/puppetlabs-concat/pull/381) ([bmjen](https://github.com/bmjen))

## [1.2.5](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.5) - 2015-12-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.4...1.2.5)

### Added

- Should fix require, refresh dependencies [#369](https://github.com/puppetlabs/puppetlabs-concat/pull/369) ([asasfu](https://github.com/asasfu))
- MODULES-1678 - Add show_diff attribute to concat and concat::fragment defined types [#368](https://github.com/puppetlabs/puppetlabs-concat/pull/368) ([jdkindy](https://github.com/jdkindy))
- Allow integer UID/GID for $owner/$group [#367](https://github.com/puppetlabs/puppetlabs-concat/pull/367) ([purplexa](https://github.com/purplexa))
- (MODULES-2303) add selinux related params to concat type [#361](https://github.com/puppetlabs/puppetlabs-concat/pull/361) ([jhoblitt](https://github.com/jhoblitt))

### Fixed

- Fix line endings on windows [#373](https://github.com/puppetlabs/puppetlabs-concat/pull/373) ([karyon](https://github.com/karyon))
- fixes resource reference in concat_file eval_generate return [#370](https://github.com/puppetlabs/puppetlabs-concat/pull/370) ([bmjen](https://github.com/bmjen))
- (MODULES-1700) Fix broken backup [#363](https://github.com/puppetlabs/puppetlabs-concat/pull/363) ([jhoblitt](https://github.com/jhoblitt))
- Revert "Backup option breaks concat" [#362](https://github.com/puppetlabs/puppetlabs-concat/pull/362) ([jhoblitt](https://github.com/jhoblitt))
- Backup option breaks concat [#359](https://github.com/puppetlabs/puppetlabs-concat/pull/359) ([j-vizcaino](https://github.com/j-vizcaino))
- Recent OpenBSD changed to ruby22 as default interpreter, that now [#358](https://github.com/puppetlabs/puppetlabs-concat/pull/358) ([buzzdeee](https://github.com/buzzdeee))

## [1.2.4](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.4) - 2015-07-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.3...1.2.4)

### Changed

- 2.0.x rewrite [#340](https://github.com/puppetlabs/puppetlabs-concat/pull/340) ([bmjen](https://github.com/bmjen))

### Added

- (#2208) FreeBSD: call /usr/local/bin/ruby explicitly [#348](https://github.com/puppetlabs/puppetlabs-concat/pull/348) ([gwollman](https://github.com/gwollman))
- check for nil [#347](https://github.com/puppetlabs/puppetlabs-concat/pull/347) ([underscorgan](https://github.com/underscorgan))
- Add helper to install puppet/pe/puppet-agent [#345](https://github.com/puppetlabs/puppetlabs-concat/pull/345) ([underscorgan](https://github.com/underscorgan))
- Add support for Solaris 12 [#344](https://github.com/puppetlabs/puppetlabs-concat/pull/344) ([drewfisher314](https://github.com/drewfisher314))
- Compare $::is_pe as bool, not string [#343](https://github.com/puppetlabs/puppetlabs-concat/pull/343) ([raphink](https://github.com/raphink))
- Add helper to install puppet/pe/puppet-agent [#339](https://github.com/puppetlabs/puppetlabs-concat/pull/339) ([hunner](https://github.com/hunner))
- (MODULES-2094) Extend regexp to remove parenthesis on safe names [#332](https://github.com/puppetlabs/puppetlabs-concat/pull/332) ([bmjen](https://github.com/bmjen))
- (MODULES-2023) - autorequire the file we are generating [#330](https://github.com/puppetlabs/puppetlabs-concat/pull/330) ([duritong](https://github.com/duritong))

### Fixed

- Revert "Add support for Solaris 12" [#357](https://github.com/puppetlabs/puppetlabs-concat/pull/357) ([underscorgan](https://github.com/underscorgan))
- Use AIO ruby if available [#352](https://github.com/puppetlabs/puppetlabs-concat/pull/352) ([underscorgan](https://github.com/underscorgan))
- fixes special characters test to support windows file restrictions [#334](https://github.com/puppetlabs/puppetlabs-concat/pull/334) ([bmjen](https://github.com/bmjen))

## [1.2.3](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.3) - 2015-06-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/2.0.1...1.2.3)

## [2.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/2.0.1) - 2015-06-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/2.0.0...2.0.1)

### Added

- adds file autorequire [#319](https://github.com/puppetlabs/puppetlabs-concat/pull/319) ([bmjen](https://github.com/bmjen))

### Fixed

- fix defaulted force behavior [#321](https://github.com/puppetlabs/puppetlabs-concat/pull/321) ([bmjen](https://github.com/bmjen))
- (MODULES-2080) Call out changed behaviour of 'warn' parameter [#320](https://github.com/puppetlabs/puppetlabs-concat/pull/320) ([DavidS](https://github.com/DavidS))
- fix fragment target handling [#318](https://github.com/puppetlabs/puppetlabs-concat/pull/318) ([bmjen](https://github.com/bmjen))
- MODULES-2054 - fixes dependency bug in creating the target file [#317](https://github.com/puppetlabs/puppetlabs-concat/pull/317) ([bmjen](https://github.com/bmjen))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/2.0.0) - 2015-05-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.2...2.0.0)

## [1.2.2](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.2) - 2015-05-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.1...1.2.2)

### Fixed

- readd ensure_newline param and tests for backwards compatibility [#307](https://github.com/puppetlabs/puppetlabs-concat/pull/307) ([bmjen](https://github.com/bmjen))
- MODULES-1933: fixes backup passing in fragments without concat resource [#303](https://github.com/puppetlabs/puppetlabs-concat/pull/303) ([bmjen](https://github.com/bmjen))
- fix for strict variables checking [#302](https://github.com/puppetlabs/puppetlabs-concat/pull/302) ([bmjen](https://github.com/bmjen))
- Revert and fix regex [#300](https://github.com/puppetlabs/puppetlabs-concat/pull/300) ([IceBear2k](https://github.com/IceBear2k))
- re-add removed params for backwards compatibility [#297](https://github.com/puppetlabs/puppetlabs-concat/pull/297) ([bmjen](https://github.com/bmjen))
- Fixes windows [#296](https://github.com/puppetlabs/puppetlabs-concat/pull/296) ([bmjen](https://github.com/bmjen))

## [1.2.1](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.1) - 2015-04-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.2.0...1.2.1)

### Fixed

- (MODULES-1700) Change the filebucketing behavior so static_compiler can ... [#288](https://github.com/puppetlabs/puppetlabs-concat/pull/288) ([woneill](https://github.com/woneill))
- setup: set user/group explicitly for dirs & script [#287](https://github.com/puppetlabs/puppetlabs-concat/pull/287) ([j-vizcaino](https://github.com/j-vizcaino))
- Fix breakage on OpenBSD in similar fashion as it is done for Windows. [#284](https://github.com/puppetlabs/puppetlabs-concat/pull/284) ([buzzdeee](https://github.com/buzzdeee))
- Set script's group to 0 if script owner is root [#280](https://github.com/puppetlabs/puppetlabs-concat/pull/280) ([thias](https://github.com/thias))
- Fixup $order parameter verification [#277](https://github.com/puppetlabs/puppetlabs-concat/pull/277) ([buzzdeee](https://github.com/buzzdeee))
- Add validation for order parameter [#275](https://github.com/puppetlabs/puppetlabs-concat/pull/275) ([underscorgan](https://github.com/underscorgan))
- Revert "Lookup is_pe fact with getvar" [#274](https://github.com/puppetlabs/puppetlabs-concat/pull/274) ([cmurphy](https://github.com/cmurphy))
- Check if $is_pe exists before using it [#270](https://github.com/puppetlabs/puppetlabs-concat/pull/270) ([raphink](https://github.com/raphink))
- set group of fragments to gid [#230](https://github.com/puppetlabs/puppetlabs-concat/pull/230) ([duritong](https://github.com/duritong))

## [1.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/1.2.0) - 2015-02-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.1.2...1.2.0)

### Fixed

- Remove shell script [#266](https://github.com/puppetlabs/puppetlabs-concat/pull/266) ([underscorgan](https://github.com/underscorgan))
- Fix validate_cmd file resource parameter [#263](https://github.com/puppetlabs/puppetlabs-concat/pull/263) ([cmurphy](https://github.com/cmurphy))
- MODULES-1456 - make sure ruby is in path on PE [#261](https://github.com/puppetlabs/puppetlabs-concat/pull/261) ([underscorgan](https://github.com/underscorgan))
- MODULES-1764 Fix missing method for check_is_owned_by for windows [#260](https://github.com/puppetlabs/puppetlabs-concat/pull/260) ([cyberious](https://github.com/cyberious))
- Add IntelliJ files to the ignore list [#254](https://github.com/puppetlabs/puppetlabs-concat/pull/254) ([cmurphy](https://github.com/cmurphy))
- Use the correct path on 32bit windows [#247](https://github.com/puppetlabs/puppetlabs-concat/pull/247) ([underscorgan](https://github.com/underscorgan))
- MODULES-1456 - make sure ruby is in path on PE [#246](https://github.com/puppetlabs/puppetlabs-concat/pull/246) ([underscorgan](https://github.com/underscorgan))
- Support running a validation command on the destination file. [#243](https://github.com/puppetlabs/puppetlabs-concat/pull/243) ([jmkeyes](https://github.com/jmkeyes))
- Reset poisoned defaults from Exec [#231](https://github.com/puppetlabs/puppetlabs-concat/pull/231) ([GeoffWilliams](https://github.com/GeoffWilliams))

## [1.1.2](https://github.com/puppetlabs/puppetlabs-concat/tree/1.1.2) - 2014-10-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.1.1...1.1.2)

### Fixed

- Use apply manifest instead of timeout transaction if it hangs [#241](https://github.com/puppetlabs/puppetlabs-concat/pull/241) ([cyberious](https://github.com/cyberious))

## [1.1.1](https://github.com/puppetlabs/puppetlabs-concat/tree/1.1.1) - 2014-09-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.4...1.1.1)

### Fixed

- Remove deprecated puppet_module_install in favor of copy_module_to [#222](https://github.com/puppetlabs/puppetlabs-concat/pull/222) ([cyberious](https://github.com/cyberious))
- fix: permitting $backup to be boolean false [#208](https://github.com/puppetlabs/puppetlabs-concat/pull/208) ([flypenguin](https://github.com/flypenguin))
- Fix errors with the future parser. [#206](https://github.com/puppetlabs/puppetlabs-concat/pull/206) ([bobtfish](https://github.com/bobtfish))
- fix concat broken on windows due to case sensitive regexp -- fixes MODULES-1203 [#204](https://github.com/puppetlabs/puppetlabs-concat/pull/204) ([GeoffWilliams](https://github.com/GeoffWilliams))

## [1.0.4](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.4) - 2014-07-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.3...1.0.4)

## [1.0.3](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.3) - 2014-06-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.1.0...1.0.3)

### Fixed

- Remove all the eq() checks as this breaks in PE3.3. [#188](https://github.com/puppetlabs/puppetlabs-concat/pull/188) ([apenney](https://github.com/apenney))
- Validate the concat::fragment order parameter as string||integer [#185](https://github.com/puppetlabs/puppetlabs-concat/pull/185) ([jhoblitt](https://github.com/jhoblitt))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/1.1.0) - 2014-05-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.2...1.1.0)

### Fixed

- fix numeric sorting [#174](https://github.com/puppetlabs/puppetlabs-concat/pull/174) ([bdeak](https://github.com/bdeak))
- Use explicit undef in else case [#155](https://github.com/puppetlabs/puppetlabs-concat/pull/155) ([PierreR](https://github.com/PierreR))

## [1.0.2](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.2) - 2014-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.1...1.0.2)

### Added

- Add in missing files to work around Puppet bug. [#168](https://github.com/puppetlabs/puppetlabs-concat/pull/168) ([apenney](https://github.com/apenney))

### Fixed

- Lets can't be used outside of a test context [#161](https://github.com/puppetlabs/puppetlabs-concat/pull/161) ([hunner](https://github.com/hunner))
- Use tmpdir instead of /tmp for windows compatability [#160](https://github.com/puppetlabs/puppetlabs-concat/pull/160) ([hunner](https://github.com/hunner))
- Avoid multi-line greps on solaris 10 [#157](https://github.com/puppetlabs/puppetlabs-concat/pull/157) ([hunner](https://github.com/hunner))
- Fix aix/windows ownership issues and vardir path [#156](https://github.com/puppetlabs/puppetlabs-concat/pull/156) ([hunner](https://github.com/hunner))

## [1.0.1](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.1) - 2014-02-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.1.0-rc1...1.0.1)

### Fixed

- Bugfixes [#139](https://github.com/puppetlabs/puppetlabs-concat/pull/139) ([apenney](https://github.com/apenney))
- Fix ensure => absent with path => set. [#134](https://github.com/puppetlabs/puppetlabs-concat/pull/134) ([apenney](https://github.com/apenney))

## [1.1.0-rc1](https://github.com/puppetlabs/puppetlabs-concat/tree/1.1.0-rc1) - 2014-01-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.0...1.1.0-rc1)

### Added

- allow source param to concat::fragment to be a string or an Array [#103](https://github.com/puppetlabs/puppetlabs-concat/pull/103) ([jhoblitt](https://github.com/jhoblitt))
- add rspec-puppet pending test for warning on inclusion of concat::setup [#98](https://github.com/puppetlabs/puppetlabs-concat/pull/98) ([jhoblitt](https://github.com/jhoblitt))
- allow concat::fragment target param to be an arbitrary string [#94](https://github.com/puppetlabs/puppetlabs-concat/pull/94) ([jhoblitt](https://github.com/jhoblitt))
- add deprecation warnings on removed parameters + warn on inclusion of co... [#90](https://github.com/puppetlabs/puppetlabs-concat/pull/90) ([jhoblitt](https://github.com/jhoblitt))
- Param validation [#83](https://github.com/puppetlabs/puppetlabs-concat/pull/83) ([jhoblitt](https://github.com/jhoblitt))
- Add Windows support [#79](https://github.com/puppetlabs/puppetlabs-concat/pull/79) ([luisfdez](https://github.com/luisfdez))
- Fragments [#71](https://github.com/puppetlabs/puppetlabs-concat/pull/71) ([apenney](https://github.com/apenney))
- Add an $ensure parameter to concat [#39](https://github.com/puppetlabs/puppetlabs-concat/pull/39) ([FredericLespez](https://github.com/FredericLespez))

### Fixed

- revert concat $warn/$warn_message param split + add deprecation warnings [#124](https://github.com/puppetlabs/puppetlabs-concat/pull/124) ([jhoblitt](https://github.com/jhoblitt))
-  fix regression preventing usage of fragment ensure => /target syntax [#117](https://github.com/puppetlabs/puppetlabs-concat/pull/117) ([jhoblitt](https://github.com/jhoblitt))
- deprecate concat::fragment mode, owner, & group params [#95](https://github.com/puppetlabs/puppetlabs-concat/pull/95) ([jhoblitt](https://github.com/jhoblitt))
- remove purging of /usr/local/bin/concatfragments.sh [#86](https://github.com/puppetlabs/puppetlabs-concat/pull/86) ([jhoblitt](https://github.com/jhoblitt))
- remove default owner/user and group values [#85](https://github.com/puppetlabs/puppetlabs-concat/pull/85) ([jhoblitt](https://github.com/jhoblitt))
- only backup target concat file + remove backup param from concat::fragme... [#84](https://github.com/puppetlabs/puppetlabs-concat/pull/84) ([jhoblitt](https://github.com/jhoblitt))
- Fix group ownership on files. [#81](https://github.com/puppetlabs/puppetlabs-concat/pull/81) ([bleach](https://github.com/bleach))
- remove undocumented requirement to include concat::setup in manifest [#77](https://github.com/puppetlabs/puppetlabs-concat/pull/77) ([jhoblitt](https://github.com/jhoblitt))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.0) - 2013-08-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/1.0.0-rc1...1.0.0)

## [1.0.0-rc1](https://github.com/puppetlabs/puppetlabs-concat/tree/1.0.0-rc1) - 2013-08-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/0.2.0...1.0.0-rc1)

### Added

- Update concatfragments.sh  [#63](https://github.com/puppetlabs/puppetlabs-concat/pull/63) ([plantigrade](https://github.com/plantigrade))
- add ensure_newline [#61](https://github.com/puppetlabs/puppetlabs-concat/pull/61) ([tmclaugh](https://github.com/tmclaugh))
- Allow WARNMSG to contain/start with '#' [#46](https://github.com/puppetlabs/puppetlabs-concat/pull/46) ([andir](https://github.com/andir))
- added (file) $replace parameter to concat [#38](https://github.com/puppetlabs/puppetlabs-concat/pull/38) ([jpoppe](https://github.com/jpoppe))

### Fixed

- Added -r flag to read so that filenames with \ will be read correctly [#44](https://github.com/puppetlabs/puppetlabs-concat/pull/44) ([abohne](https://github.com/abohne))

## [0.2.0](https://github.com/puppetlabs/puppetlabs-concat/tree/0.2.0) - 2012-09-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/0.1.0...0.2.0)

### Added

- Allow using a custom name and provide a path to the file that needs to be created using concat. [#31](https://github.com/puppetlabs/puppetlabs-concat/pull/31) ([vStone](https://github.com/vStone))
- Improvements [#24](https://github.com/puppetlabs/puppetlabs-concat/pull/24) ([pabelanger](https://github.com/pabelanger))

### Fixed

- Include concat::setup from concat, so users don't need to [#27](https://github.com/puppetlabs/puppetlabs-concat/pull/27) ([djmitche](https://github.com/djmitche))
- Remove spurious 'e' character. [#26](https://github.com/puppetlabs/puppetlabs-concat/pull/26) ([djmitche](https://github.com/djmitche))
- Fix module name to make the PMT happier [#25](https://github.com/puppetlabs/puppetlabs-concat/pull/25) ([branan](https://github.com/branan))
- Fail with helpful advice if $::concat_basedir is not yet set [#21](https://github.com/puppetlabs/puppetlabs-concat/pull/21) ([mrwacky42](https://github.com/mrwacky42))

## [0.1.0](https://github.com/puppetlabs/puppetlabs-concat/tree/0.1.0) - 2012-04-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-concat/compare/ee1fe7a0236e5fd100bbc229ea034bf7d2b530aa...0.1.0)
