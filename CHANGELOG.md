# Change log

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not impact the functionality of the module.

## [v4.1.3](https://github.com/voxpupuli/puppet-zabbix/tree/v4.1.3) (2017-06-26)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.1.2...v4.1.3)

**Fixed bugs:**

- zabbix::agent LogType and User are not valid in 2.2 \(EPEL\) [\#417](https://github.com/voxpupuli/puppet-zabbix/issues/417)
- Add pg\_hba rule to allow zabbix server \#411 [\#412](https://github.com/voxpupuli/puppet-zabbix/pull/412) ([RaphaelNeumann](https://github.com/RaphaelNeumann))

**Merged pull requests:**

- bump postgresql to allow 5.X [\#420](https://github.com/voxpupuli/puppet-zabbix/pull/420) ([bastelfreak](https://github.com/bastelfreak))

## [v4.1.2](https://github.com/voxpupuli/puppet-zabbix/tree/v4.1.2) (2017-06-23)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.1.1...v4.1.2)

**Implemented enhancements:**

- Update metadata.json for correct stdlib/puppet version [\#415](https://github.com/voxpupuli/puppet-zabbix/pull/415) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix proxy service not being enabled [\#413](https://github.com/voxpupuli/puppet-zabbix/pull/413) ([stefanandres](https://github.com/stefanandres))

**Merged pull requests:**

- release 4.1.2 [\#416](https://github.com/voxpupuli/puppet-zabbix/pull/416) ([bastelfreak](https://github.com/bastelfreak))

## [v4.1.1](https://github.com/voxpupuli/puppet-zabbix/tree/v4.1.1) (2017-06-14)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.1.0...v4.1.1)

**Fixed bugs:**

- unless $manage\_database interprets False wrong; and useless require breaks standalone database setups [\#409](https://github.com/voxpupuli/puppet-zabbix/pull/409) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- release 4.1.1 [\#410](https://github.com/voxpupuli/puppet-zabbix/pull/410) ([bastelfreak](https://github.com/bastelfreak))

## [v4.1.0](https://github.com/voxpupuli/puppet-zabbix/tree/v4.1.0) (2017-06-08)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Allow zabbix server to run on a dedicated machine [\#406](https://github.com/voxpupuli/puppet-zabbix/issues/406)
- Zabbix server should not be started as root [\#405](https://github.com/voxpupuli/puppet-zabbix/issues/405)
- Allow zabbix upgrades via the module [\#403](https://github.com/voxpupuli/puppet-zabbix/issues/403)
- update rpm key urls to https [\#401](https://github.com/voxpupuli/puppet-zabbix/pull/401) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Zabbix agent should be started forking on 2.X and simple on 3.X [\#404](https://github.com/voxpupuli/puppet-zabbix/issues/404)
- Fails to upgrade zabbix-agent if zabbix\_version is changed [\#398](https://github.com/voxpupuli/puppet-zabbix/issues/398)
- Zabbix Repository \(zabbix-non-supported\) defined with incorrect gpgkey [\#397](https://github.com/voxpupuli/puppet-zabbix/issues/397)
- define owner and group via parameters [\#400](https://github.com/voxpupuli/puppet-zabbix/pull/400) ([kBite](https://github.com/kBite))
- only add --foreground on 3.0 and newer [\#396](https://github.com/voxpupuli/puppet-zabbix/pull/396) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Zabbix 3.0 on Centos 6.x [\#359](https://github.com/voxpupuli/puppet-zabbix/issues/359)
- Integer 18455137360 too big to convert to "int" at manifests/params.pp:333:24 [\#329](https://github.com/voxpupuli/puppet-zabbix/issues/329)

**Merged pull requests:**

- release 4.1.0 [\#402](https://github.com/voxpupuli/puppet-zabbix/pull/402) ([bastelfreak](https://github.com/bastelfreak))
- Fix rpm key handling + changing default values depending on zabbix version [\#399](https://github.com/voxpupuli/puppet-zabbix/pull/399) ([bastelfreak](https://github.com/bastelfreak))
- Provide acceptance tests for zabbix server [\#392](https://github.com/voxpupuli/puppet-zabbix/pull/392) ([bastelfreak](https://github.com/bastelfreak))

## [v4.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v4.0.0) (2017-05-24)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v3.0.0...v4.0.0)

**Implemented enhancements:**

- update to new archlinux package name [\#381](https://github.com/voxpupuli/puppet-zabbix/pull/381) ([bastelfreak](https://github.com/bastelfreak))
- remove the include ::apt [\#369](https://github.com/voxpupuli/puppet-zabbix/pull/369) ([damoxc](https://github.com/damoxc))
- replace all validate functions with datatypes [\#362](https://github.com/voxpupuli/puppet-zabbix/pull/362) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Release 4.0.0 [\#390](https://github.com/voxpupuli/puppet-zabbix/pull/390) ([dhollinger](https://github.com/dhollinger))
- modulesync 0.21.3 [\#388](https://github.com/voxpupuli/puppet-zabbix/pull/388) ([bastelfreak](https://github.com/bastelfreak))
- migrate userparameters tests to rspec-puppet-facts [\#387](https://github.com/voxpupuli/puppet-zabbix/pull/387) ([bastelfreak](https://github.com/bastelfreak))
- migrate proxy tests to rspec-puppet-facts [\#386](https://github.com/voxpupuli/puppet-zabbix/pull/386) ([bastelfreak](https://github.com/bastelfreak))
- add rspec-puppet-facts to repo.pp [\#385](https://github.com/voxpupuli/puppet-zabbix/pull/385) ([bastelfreak](https://github.com/bastelfreak))
- Enhance tests for javagateway [\#384](https://github.com/voxpupuli/puppet-zabbix/pull/384) ([bastelfreak](https://github.com/bastelfreak))
- Migrate tests to rspec-puppet-facts [\#383](https://github.com/voxpupuli/puppet-zabbix/pull/383) ([bastelfreak](https://github.com/bastelfreak))
- BREAKING: Add acceptance tests + multiple bugfixes [\#382](https://github.com/voxpupuli/puppet-zabbix/pull/382) ([bastelfreak](https://github.com/bastelfreak))
- Fix github license detection [\#379](https://github.com/voxpupuli/puppet-zabbix/pull/379) ([alexjfisher](https://github.com/alexjfisher))
- puppet-lint: fix arrow\_on\_right\_operand\_line [\#375](https://github.com/voxpupuli/puppet-zabbix/pull/375) ([bastelfreak](https://github.com/bastelfreak))
- update README.md so everything is rendered correctly [\#370](https://github.com/voxpupuli/puppet-zabbix/pull/370) ([Cosaquee](https://github.com/Cosaquee))
- bump rubocop-rspec 1.10.0-\>1.13.0 [\#367](https://github.com/voxpupuli/puppet-zabbix/pull/367) ([bastelfreak](https://github.com/bastelfreak))
- bump puppetlabs\_spec\_helper 2.0.1-\>2.1.0 [\#366](https://github.com/voxpupuli/puppet-zabbix/pull/366) ([bastelfreak](https://github.com/bastelfreak))
- Fixed syntax error in README template [\#361](https://github.com/voxpupuli/puppet-zabbix/pull/361) ([angeiv](https://github.com/angeiv))

## [v3.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v3.0.0) (2017-02-12)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.6.2...v3.0.0)

**Implemented enhancements:**

- added javagateway timeout [\#348](https://github.com/voxpupuli/puppet-zabbix/pull/348) ([onzyone](https://github.com/onzyone))

**Closed issues:**

- zabbix::web Could not find user zabbix [\#341](https://github.com/voxpupuli/puppet-zabbix/issues/341)

**Merged pull requests:**

- release 3.0.0 [\#354](https://github.com/voxpupuli/puppet-zabbix/pull/354) ([bastelfreak](https://github.com/bastelfreak))
- Change minimum required Puppet version to 4.6.1.  Puppet 3 is no longer supported. [\#345](https://github.com/voxpupuli/puppet-zabbix/pull/345) ([bastelfreak](https://github.com/bastelfreak))

## [v2.6.2](https://github.com/voxpupuli/puppet-zabbix/tree/v2.6.2) (2017-01-11)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.6.1...v2.6.2)

**Closed issues:**

- Installing on 2 nodes does not setup the database [\#333](https://github.com/voxpupuli/puppet-zabbix/issues/333)

**Merged pull requests:**

- release 2.6.2 [\#343](https://github.com/voxpupuli/puppet-zabbix/pull/343) ([bastelfreak](https://github.com/bastelfreak))
- Fix failing test due to missing selinux fact [\#332](https://github.com/voxpupuli/puppet-zabbix/pull/332) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Bump min version\_requirement for Puppet + deps [\#331](https://github.com/voxpupuli/puppet-zabbix/pull/331) ([juniorsysadmin](https://github.com/juniorsysadmin))
- release 2.6.1 [\#327](https://github.com/voxpupuli/puppet-zabbix/pull/327) ([bastelfreak](https://github.com/bastelfreak))

## [v2.6.1](https://github.com/voxpupuli/puppet-zabbix/tree/v2.6.1) (2016-12-07)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.6.0...v2.6.1)

**Closed issues:**

- Puppet Unknown variable: '::selinux\_config\_mode' [\#325](https://github.com/voxpupuli/puppet-zabbix/issues/325)
- Zabbix agent should not use ProtectSystem in systemd [\#320](https://github.com/voxpupuli/puppet-zabbix/issues/320)
- related to \#305 run fails if system does not have systemd fact [\#310](https://github.com/voxpupuli/puppet-zabbix/issues/310)

**Merged pull requests:**

- Strict variables fix for selinux\_config\_mode [\#326](https://github.com/voxpupuli/puppet-zabbix/pull/326) ([alexjfisher](https://github.com/alexjfisher))
- Add virtual bridge \(virbr\) to the list of network interfaces that are checked when setting listenip [\#324](https://github.com/voxpupuli/puppet-zabbix/pull/324) ([markfaine](https://github.com/markfaine))
- Replaced agent systemd service with official [\#321](https://github.com/voxpupuli/puppet-zabbix/pull/321) ([BcTpe4HbIu](https://github.com/BcTpe4HbIu))
- Improve zabbix\_template type [\#318](https://github.com/voxpupuli/puppet-zabbix/pull/318) ([alexjfisher](https://github.com/alexjfisher))
- Add unit test for zabbix\_hostgroup type [\#316](https://github.com/voxpupuli/puppet-zabbix/pull/316) ([alexjfisher](https://github.com/alexjfisher))
- Add missing badges \[ci skip\] [\#315](https://github.com/voxpupuli/puppet-zabbix/pull/315) ([alexjfisher](https://github.com/alexjfisher))
- Default web\_config\_owner/group correctly [\#313](https://github.com/voxpupuli/puppet-zabbix/pull/313) ([alexjfisher](https://github.com/alexjfisher))

## [v2.6.0](https://github.com/voxpupuli/puppet-zabbix/tree/v2.6.0) (2016-11-04)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.5.1...v2.6.0)

**Merged pull requests:**

- release 2.6.0 [\#309](https://github.com/voxpupuli/puppet-zabbix/pull/309) ([bastelfreak](https://github.com/bastelfreak))
- In case we are not using Apache we should have an option to define ow… [\#307](https://github.com/voxpupuli/puppet-zabbix/pull/307) ([admont](https://github.com/admont))
- use getvar to get systemd fact [\#305](https://github.com/voxpupuli/puppet-zabbix/pull/305) ([bastelfreak](https://github.com/bastelfreak))
- make rspec more awesome [\#304](https://github.com/voxpupuli/puppet-zabbix/pull/304) ([bastelfreak](https://github.com/bastelfreak))
- Enhance testing [\#302](https://github.com/voxpupuli/puppet-zabbix/pull/302) ([bastelfreak](https://github.com/bastelfreak))
- Add new RPM GPG key for zabbix-3.2 and higher [\#300](https://github.com/voxpupuli/puppet-zabbix/pull/300) ([yevtushenko](https://github.com/yevtushenko))
- Add MySQL tests for zabbix-3.2. [\#299](https://github.com/voxpupuli/puppet-zabbix/pull/299) ([yevtushenko](https://github.com/yevtushenko))

## [v2.5.1](https://github.com/voxpupuli/puppet-zabbix/tree/v2.5.1) (2016-10-13)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.5.0...v2.5.1)

**Closed issues:**

- zabbix\_proxy.rb:7: syntax error [\#281](https://github.com/voxpupuli/puppet-zabbix/issues/281)
- The zabbix\_host custom type doesn't appear to recognise the "group" parameter [\#280](https://github.com/voxpupuli/puppet-zabbix/issues/280)
- zabbix-agentd can't start on CentOS 6.x [\#264](https://github.com/voxpupuli/puppet-zabbix/issues/264)

**Merged pull requests:**

- release 2.5.1 [\#295](https://github.com/voxpupuli/puppet-zabbix/pull/295) ([bastelfreak](https://github.com/bastelfreak))
- Fixes for \#264 [\#291](https://github.com/voxpupuli/puppet-zabbix/pull/291) ([shaunrampersad](https://github.com/shaunrampersad))
- Adapt to zabbix-3.2 and higher. [\#289](https://github.com/voxpupuli/puppet-zabbix/pull/289) ([yevtushenko](https://github.com/yevtushenko))
- Fix for php db package name on Ubuntu 16.04 [\#284](https://github.com/voxpupuli/puppet-zabbix/pull/284) ([frozenfoxx](https://github.com/frozenfoxx))
- Fix typo error [\#279](https://github.com/voxpupuli/puppet-zabbix/pull/279) ([int32bit](https://github.com/int32bit))
- don't fail if uncompressed file exists [\#278](https://github.com/voxpupuli/puppet-zabbix/pull/278) ([HT43-bqxFqB](https://github.com/HT43-bqxFqB))

## [v2.5.0](https://github.com/voxpupuli/puppet-zabbix/tree/v2.5.0) (2016-09-19)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- modulesync 0.12.2 + Improvements [\#268](https://github.com/voxpupuli/puppet-zabbix/pull/268) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- zabbix-agent service not starting properly, missing variables in zabbix-agent.service file [\#266](https://github.com/voxpupuli/puppet-zabbix/issues/266)
- Release 999.999.999 version of wdijkerman for deprecation [\#243](https://github.com/voxpupuli/puppet-zabbix/issues/243)

**Merged pull requests:**

- Release 2.5.0 [\#277](https://github.com/voxpupuli/puppet-zabbix/pull/277) ([bastelfreak](https://github.com/bastelfreak))
- Add Fedora 24 support [\#275](https://github.com/voxpupuli/puppet-zabbix/pull/275) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.0](https://github.com/voxpupuli/puppet-zabbix/tree/v2.4.0) (2016-08-18)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.3.2...v2.4.0)

**Closed issues:**

- Custom config file name/path [\#240](https://github.com/voxpupuli/puppet-zabbix/issues/240)
- 'apt-get update' complains about a weak digest \(SHA1\) [\#239](https://github.com/voxpupuli/puppet-zabbix/issues/239)
- Order problems with apt update [\#233](https://github.com/voxpupuli/puppet-zabbix/issues/233)
- Unpin concat version, support 2.x [\#231](https://github.com/voxpupuli/puppet-zabbix/issues/231)
- Update metadata.json and fixtures to support concat [\#230](https://github.com/voxpupuli/puppet-zabbix/issues/230)

**Merged pull requests:**

- Create tests for commit efad625cd87ce37fe91e708920da6a85b1f28e4b [\#263](https://github.com/voxpupuli/puppet-zabbix/pull/263) ([Heidistein](https://github.com/Heidistein))
- Modulesync 0.12.1 & Release 2.4.0 [\#261](https://github.com/voxpupuli/puppet-zabbix/pull/261) ([bastelfreak](https://github.com/bastelfreak))
- Fix: Pin Rubocop version to 2.0.0+ [\#255](https://github.com/voxpupuli/puppet-zabbix/pull/255) ([jk2l](https://github.com/jk2l))
- Respect user provided Zabbix agent package name in userparameters [\#254](https://github.com/voxpupuli/puppet-zabbix/pull/254) ([wiene](https://github.com/wiene))
- Fix: select systemd for ubuntu correctly [\#252](https://github.com/voxpupuli/puppet-zabbix/pull/252) ([jk2l](https://github.com/jk2l))
- Add manage\_service option.  [\#251](https://github.com/voxpupuli/puppet-zabbix/pull/251) ([Heidistein](https://github.com/Heidistein))
- Fix: manage database parameter not pass to zabbix::server [\#249](https://github.com/voxpupuli/puppet-zabbix/pull/249) ([jk2l](https://github.com/jk2l))
- Fix: add historyindexcachesize option to server and proxy code [\#248](https://github.com/voxpupuli/puppet-zabbix/pull/248) ([shoikan](https://github.com/shoikan))
- Fix for issue \#240 [\#246](https://github.com/voxpupuli/puppet-zabbix/pull/246) ([fgallese](https://github.com/fgallese))
- Set selboolean for zabbix proxy [\#235](https://github.com/voxpupuli/puppet-zabbix/pull/235) ([sgnl05](https://github.com/sgnl05))
- Added package tagging for apt update workflow. [\#234](https://github.com/voxpupuli/puppet-zabbix/pull/234) ([ITler](https://github.com/ITler))
- Fix Concat pinning [\#232](https://github.com/voxpupuli/puppet-zabbix/pull/232) ([bastelfreak](https://github.com/bastelfreak))
- Allows setting ListenIP as "lo" loopback interface. [\#229](https://github.com/voxpupuli/puppet-zabbix/pull/229) ([felipe1982](https://github.com/felipe1982))
- Manage default\_vhost in zabbix main class. [\#226](https://github.com/voxpupuli/puppet-zabbix/pull/226) ([furhouse](https://github.com/furhouse))

## [v2.3.2](https://github.com/voxpupuli/puppet-zabbix/tree/v2.3.2) (2016-05-21)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.3.1...v2.3.2)

**Merged pull requests:**

- Modulesync + Release 2.3.2 [\#227](https://github.com/voxpupuli/puppet-zabbix/pull/227) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.1](https://github.com/voxpupuli/puppet-zabbix/tree/v2.3.1) (2016-05-20)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.3.0...v2.3.1)

**Closed issues:**

- What is selinux\_config\_mode? [\#222](https://github.com/voxpupuli/puppet-zabbix/issues/222)
- 404 not found [\#219](https://github.com/voxpupuli/puppet-zabbix/issues/219)
-  undefined local variable or method `int\_name' [\#216](https://github.com/voxpupuli/puppet-zabbix/issues/216)

**Merged pull requests:**

- Modulesync + Release [\#225](https://github.com/voxpupuli/puppet-zabbix/pull/225) ([bastelfreak](https://github.com/bastelfreak))
- Introduce rspec-puppet-facts for some tests [\#224](https://github.com/voxpupuli/puppet-zabbix/pull/224) ([bastelfreak](https://github.com/bastelfreak))
- Make module run with ubuntu. [\#223](https://github.com/voxpupuli/puppet-zabbix/pull/223) ([ITler](https://github.com/ITler))
- add CONTRIBUTORS from git log [\#220](https://github.com/voxpupuli/puppet-zabbix/pull/220) ([bastelfreak](https://github.com/bastelfreak))
- Introduce rspec-puppet-facts for some tests [\#218](https://github.com/voxpupuli/puppet-zabbix/pull/218) ([bastelfreak](https://github.com/bastelfreak))
- Fix216 [\#217](https://github.com/voxpupuli/puppet-zabbix/pull/217) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-zabbix/tree/v2.3.0) (2016-05-08)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/2.2.0...v2.3.0)

**Closed issues:**

- Web interface config file readable by all \(contains unencrypted database password\) [\#200](https://github.com/voxpupuli/puppet-zabbix/issues/200)
- Update zabbixapi gem to 2.4.7 form Zabbix 3.0 [\#196](https://github.com/voxpupuli/puppet-zabbix/issues/196)
- Add support for zabbix sender [\#194](https://github.com/voxpupuli/puppet-zabbix/issues/194)
- SELinux - CentOs 7 [\#190](https://github.com/voxpupuli/puppet-zabbix/issues/190)
- AMZ Linux Support  [\#187](https://github.com/voxpupuli/puppet-zabbix/issues/187)
- Zabbix as default vhost [\#180](https://github.com/voxpupuli/puppet-zabbix/issues/180)

**Merged pull requests:**

- Prepare release 2.3.0 [\#215](https://github.com/voxpupuli/puppet-zabbix/pull/215) ([bastelfreak](https://github.com/bastelfreak))
- fix typo in zabbix\_host provider [\#211](https://github.com/voxpupuli/puppet-zabbix/pull/211) ([damoxc](https://github.com/damoxc))
- Missing zabbix\_url in create [\#209](https://github.com/voxpupuli/puppet-zabbix/pull/209) ([cbergmann](https://github.com/cbergmann))
- userparameters not working. [\#208](https://github.com/voxpupuli/puppet-zabbix/pull/208) ([cbergmann](https://github.com/cbergmann))
- add Arch Linux to metadata.json [\#207](https://github.com/voxpupuli/puppet-zabbix/pull/207) ([bastelfreak](https://github.com/bastelfreak))
- Enhance spec testing [\#206](https://github.com/voxpupuli/puppet-zabbix/pull/206) ([bastelfreak](https://github.com/bastelfreak))
- Update rubocop [\#204](https://github.com/voxpupuli/puppet-zabbix/pull/204) ([bastelfreak](https://github.com/bastelfreak))
- Update rspec [\#203](https://github.com/voxpupuli/puppet-zabbix/pull/203) ([bastelfreak](https://github.com/bastelfreak))
- Add archlinux support [\#201](https://github.com/voxpupuli/puppet-zabbix/pull/201) ([bastelfreak](https://github.com/bastelfreak))
- there is no zabbix proxy package in zbx-3.0 [\#198](https://github.com/voxpupuli/puppet-zabbix/pull/198) ([BcTpe4HbIu](https://github.com/BcTpe4HbIu))
- Zabbix as default vhost \#180 [\#197](https://github.com/voxpupuli/puppet-zabbix/pull/197) ([szemlyanoy](https://github.com/szemlyanoy))
- Add Zabbix sender support [\#195](https://github.com/voxpupuli/puppet-zabbix/pull/195) ([vide](https://github.com/vide))
- fix wrong comment for configfrequency [\#192](https://github.com/voxpupuli/puppet-zabbix/pull/192) ([BcTpe4HbIu](https://github.com/BcTpe4HbIu))
- Feature selinux [\#191](https://github.com/voxpupuli/puppet-zabbix/pull/191) ([bastelfreak](https://github.com/bastelfreak))
- Fix for proxy sqlite support [\#189](https://github.com/voxpupuli/puppet-zabbix/pull/189) ([BcTpe4HbIu](https://github.com/BcTpe4HbIu))
- updated to include Amazon Linux [\#188](https://github.com/voxpupuli/puppet-zabbix/pull/188) ([ericsysmin](https://github.com/ericsysmin))

## [2.2.0](https://github.com/voxpupuli/puppet-zabbix/tree/2.2.0) (2016-03-06)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/2.1.1...2.2.0)

**Implemented enhancements:**

- Upgrading to 3.0 [\#166](https://github.com/voxpupuli/puppet-zabbix/issues/166)

**Fixed bugs:**

- Repo is always added [\#148](https://github.com/voxpupuli/puppet-zabbix/issues/148)

**Closed issues:**

- HistoryTextCacheSize is not supported in Zabbix 3.0 [\#185](https://github.com/voxpupuli/puppet-zabbix/issues/185)
- Custom API query? [\#179](https://github.com/voxpupuli/puppet-zabbix/issues/179)
- database is being managed even if manage\_database is false [\#170](https://github.com/voxpupuli/puppet-zabbix/issues/170)
- Invalid parameter key\_source on Apt::Source\[zabbix\] at /etc/puppet/environments/myenv/modules/zabbix/manifests/repo.pp:144 on node XXXXX [\#101](https://github.com/voxpupuli/puppet-zabbix/issues/101)
- Zabbix 3.0 Proxy Postgres DB Schema Using Incorrect File [\#186](https://github.com/voxpupuli/puppet-zabbix/issues/186)
- write more rspec tests to test zabbix 3.0 [\#176](https://github.com/voxpupuli/puppet-zabbix/issues/176)

**Merged pull requests:**

- Make types runnable in puppet 4 [\#181](https://github.com/voxpupuli/puppet-zabbix/pull/181) ([ITler](https://github.com/ITler))
- Added Zabbix Proxy, Agent, Server, 3.0 support and Pacemaker exclusions [\#174](https://github.com/voxpupuli/puppet-zabbix/pull/174) ([ericsysmin](https://github.com/ericsysmin))
- removed notify, forgot to take it out when I was troubleshooting [\#173](https://github.com/voxpupuli/puppet-zabbix/pull/173) ([ericsysmin](https://github.com/ericsysmin))
- Patch 6 [\#171](https://github.com/voxpupuli/puppet-zabbix/pull/171) ([ericsysmin](https://github.com/ericsysmin))
- TLS Support for Zabbix 3.0 [\#169](https://github.com/voxpupuli/puppet-zabbix/pull/169) ([ericsysmin](https://github.com/ericsysmin))
- Adjust server config and databases sqls for 3.0 [\#167](https://github.com/voxpupuli/puppet-zabbix/pull/167) ([cloudowski](https://github.com/cloudowski))

## [2.1.1](https://github.com/voxpupuli/puppet-zabbix/tree/2.1.1) (2016-02-09)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/2.1.0...2.1.1)

**Merged pull requests:**

- Make Zabbix module compile on puppet 4.x AIO. [\#164](https://github.com/voxpupuli/puppet-zabbix/pull/164) ([ITler](https://github.com/ITler))

## [2.1.0](https://github.com/voxpupuli/puppet-zabbix/tree/2.1.0) (2016-02-02)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/2.0.0...2.1.0)

**Fixed bugs:**

- The puppetgem fact is incorrect for Puppet 4 AIO installation [\#157](https://github.com/voxpupuli/puppet-zabbix/issues/157)

**Closed issues:**

- Enable Travis CI [\#161](https://github.com/voxpupuli/puppet-zabbix/issues/161)
- An IP address is required for a zabbix host [\#160](https://github.com/voxpupuli/puppet-zabbix/issues/160)

**Merged pull requests:**

- Add Puppet Forge Version and Downloads badges [\#163](https://github.com/voxpupuli/puppet-zabbix/pull/163) ([rnelson0](https://github.com/rnelson0))
- Travis CI setup: ensure all rspec tests pass [\#162](https://github.com/voxpupuli/puppet-zabbix/pull/162) ([rnelson0](https://github.com/rnelson0))
- Update proxy.pp, fix Error: ...install zabbix-proxy- .. [\#159](https://github.com/voxpupuli/puppet-zabbix/pull/159) ([subkowlex](https://github.com/subkowlex))
- Puppetgem [\#158](https://github.com/voxpupuli/puppet-zabbix/pull/158) ([rnelson0](https://github.com/rnelson0))
- Removed a debug entry [\#156](https://github.com/voxpupuli/puppet-zabbix/pull/156) ([hkumarmk](https://github.com/hkumarmk))

## [2.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/2.0.0) (2016-01-31)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.7.0...2.0.0)

**Implemented enhancements:**

- No LDAP Support [\#149](https://github.com/voxpupuli/puppet-zabbix/issues/149)

**Fixed bugs:**

- Database is always managed [\#153](https://github.com/voxpupuli/puppet-zabbix/issues/153)
- Server and Proxy templates are inconsistent [\#144](https://github.com/voxpupuli/puppet-zabbix/issues/144)

**Closed issues:**

- Repo url in RHEL or Oracle Linux [\#142](https://github.com/voxpupuli/puppet-zabbix/issues/142)
- Could not evaluate: undefined method `+' for nil:NilClass [\#134](https://github.com/voxpupuli/puppet-zabbix/issues/134)
- userparameter in RedHat Satellite 6.x [\#125](https://github.com/voxpupuli/puppet-zabbix/issues/125)
- Userparameter with Foreman  [\#117](https://github.com/voxpupuli/puppet-zabbix/issues/117)
- Invalid parameter group\_create [\#100](https://github.com/voxpupuli/puppet-zabbix/issues/100)

**Merged pull requests:**

- Type to manage zabbix application [\#155](https://github.com/voxpupuli/puppet-zabbix/pull/155) ([hkumarmk](https://github.com/hkumarmk))
- Fixed previous error in merge [\#152](https://github.com/voxpupuli/puppet-zabbix/pull/152) ([elricsfate](https://github.com/elricsfate))
- Added support for adding LDAP certificate location to Zabbix Web. Upd… [\#150](https://github.com/voxpupuli/puppet-zabbix/pull/150) ([elricsfate](https://github.com/elricsfate))
- Allow agent\_serveractive value to be blank [\#147](https://github.com/voxpupuli/puppet-zabbix/pull/147) ([ericsysmin](https://github.com/ericsysmin))
- allow serveractive to be optional [\#146](https://github.com/voxpupuli/puppet-zabbix/pull/146) ([ericsysmin](https://github.com/ericsysmin))
- fixed typo for comment mysql [\#145](https://github.com/voxpupuli/puppet-zabbix/pull/145) ([ghost](https://github.com/ghost))
- fixed SSL server template options for 2.2 [\#141](https://github.com/voxpupuli/puppet-zabbix/pull/141) ([IceBear2k](https://github.com/IceBear2k))
- fix syntax error [\#139](https://github.com/voxpupuli/puppet-zabbix/pull/139) ([mkrakowitzer](https://github.com/mkrakowitzer))
- Allow agent to listen on \* [\#138](https://github.com/voxpupuli/puppet-zabbix/pull/138) ([ekohl](https://github.com/ekohl))
- enable apache\_php\_max\_input\_vars [\#137](https://github.com/voxpupuli/puppet-zabbix/pull/137) ([bastelfreak](https://github.com/bastelfreak))
- Fix typo in zabbix-userparameters reference [\#136](https://github.com/voxpupuli/puppet-zabbix/pull/136) ([sgnl05](https://github.com/sgnl05))
- Listen on all IPs [\#133](https://github.com/voxpupuli/puppet-zabbix/pull/133) ([z3rogate](https://github.com/z3rogate))
- tap0 or tun0 \(OpenVPN interfaces\) interface as listenip [\#132](https://github.com/voxpupuli/puppet-zabbix/pull/132) ([z3rogate](https://github.com/z3rogate))
- Added zabbix\_template\_host type [\#154](https://github.com/voxpupuli/puppet-zabbix/pull/154) ([hkumarmk](https://github.com/hkumarmk))

## [1.7.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.7.0) (2015-11-07)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.6.0...1.7.0)

**Closed issues:**

- Support for PSBM [\#123](https://github.com/voxpupuli/puppet-zabbix/issues/123)
- Install Zabbix SERVER and PROXY on same machine [\#119](https://github.com/voxpupuli/puppet-zabbix/issues/119)
- zabbix::agent doesn't pass $zabbix\_version to zabbix::repo [\#118](https://github.com/voxpupuli/puppet-zabbix/issues/118)
- Syntax error at '{'; expected '}' at /etc/puppet/modules/zabbix/manifests/server.pp:340 on node zabbix [\#115](https://github.com/voxpupuli/puppet-zabbix/issues/115)
- zabbix::template failing - undefined method `configurations' [\#113](https://github.com/voxpupuli/puppet-zabbix/issues/113)
- API not working [\#111](https://github.com/voxpupuli/puppet-zabbix/issues/111)

**Merged pull requests:**

- Generalise the zabbix\_url [\#129](https://github.com/voxpupuli/puppet-zabbix/pull/129) ([DjxDeaf](https://github.com/DjxDeaf))
- Added supporting new Zabbix params [\#128](https://github.com/voxpupuli/puppet-zabbix/pull/128) ([akostetskiy](https://github.com/akostetskiy))
- refactoring of repo.pp [\#126](https://github.com/voxpupuli/puppet-zabbix/pull/126) ([bastelfreak](https://github.com/bastelfreak))
- Fping wrong path in debian [\#124](https://github.com/voxpupuli/puppet-zabbix/pull/124) ([Oyabi](https://github.com/Oyabi))
- add support for CloudLinux [\#122](https://github.com/voxpupuli/puppet-zabbix/pull/122) ([bastelfreak](https://github.com/bastelfreak))
- Update template.pp [\#121](https://github.com/voxpupuli/puppet-zabbix/pull/121) ([claflico](https://github.com/claflico))
- misspelled parameter path [\#116](https://github.com/voxpupuli/puppet-zabbix/pull/116) ([karolisc](https://github.com/karolisc))

## [1.6.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.6.0) (2015-08-21)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.5.0...1.6.0)

**Fixed bugs:**

- " Using allow is not supported in your Apache version" [\#72](https://github.com/voxpupuli/puppet-zabbix/issues/72)
- zabbix\_version ignored [\#105](https://github.com/voxpupuli/puppet-zabbix/issues/105)

**Closed issues:**

- zabbix::repo doest not inherit zabbix::params [\#93](https://github.com/voxpupuli/puppet-zabbix/issues/93)
- Agent Config Template [\#112](https://github.com/voxpupuli/puppet-zabbix/issues/112)
- Feature Request: add charset/collate option during a mysql db resource creation [\#107](https://github.com/voxpupuli/puppet-zabbix/issues/107)

**Merged pull requests:**

- Pass manage\_repo and zabbix\_repo to repo.pp and prevent double include [\#110](https://github.com/voxpupuli/puppet-zabbix/pull/110) ([mmerfort](https://github.com/mmerfort))
- Add "eno\*" to interface name matching [\#104](https://github.com/voxpupuli/puppet-zabbix/pull/104) ([sgnl05](https://github.com/sgnl05))
- use the new puppetlabs-apt version 2.x module [\#103](https://github.com/voxpupuli/puppet-zabbix/pull/103) ([hmn](https://github.com/hmn))
- Fix name startvmwarecollector -\> startvmwarecollectors [\#102](https://github.com/voxpupuli/puppet-zabbix/pull/102) ([BcTpe4HbIu](https://github.com/BcTpe4HbIu))
- Custom apache IP and port [\#99](https://github.com/voxpupuli/puppet-zabbix/pull/99) ([mschuett](https://github.com/mschuett))
- Pass zabbix\_version and manage\_repo to zabbix::repo [\#88](https://github.com/voxpupuli/puppet-zabbix/pull/88) ([mmerfort](https://github.com/mmerfort))

## [1.5.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.5.0) (2015-06-08)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.4.0...1.5.0)

**Implemented enhancements:**

- File extensions of Userparameters scripts [\#97](https://github.com/voxpupuli/puppet-zabbix/issues/97)
- new postgresql instance [\#91](https://github.com/voxpupuli/puppet-zabbix/issues/91)

**Fixed bugs:**

- Zabbix-proxy install database population [\#62](https://github.com/voxpupuli/puppet-zabbix/issues/62)

**Closed issues:**

- new web instance [\#92](https://github.com/voxpupuli/puppet-zabbix/issues/92)

**Merged pull requests:**

- merge of hiera hashes from entire hierarchy [\#98](https://github.com/voxpupuli/puppet-zabbix/pull/98) ([szemlyanoy](https://github.com/szemlyanoy))
- Added support to Amazon Linux with epel 6. [\#96](https://github.com/voxpupuli/puppet-zabbix/pull/96) ([Wprosdocimo](https://github.com/Wprosdocimo))
- import templates and create hostgroup if missing [\#95](https://github.com/voxpupuli/puppet-zabbix/pull/95) ([1n](https://github.com/1n))
- Added Support For Zapache monitoring script [\#94](https://github.com/voxpupuli/puppet-zabbix/pull/94) ([elricsfate](https://github.com/elricsfate))

## [1.4.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.4.0) (2015-05-18)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.3.0...1.4.0)

**Fixed bugs:**

- Unable to install version 2.2 [\#76](https://github.com/voxpupuli/puppet-zabbix/issues/76)
- Add dependency on apt [\#74](https://github.com/voxpupuli/puppet-zabbix/issues/74)

**Closed issues:**

- manage\_firewall is set to 'false' by default [\#86](https://github.com/voxpupuli/puppet-zabbix/issues/86)
- Cannot install on Jessie [\#85](https://github.com/voxpupuli/puppet-zabbix/issues/85)
- setting Hostname and HostnameItem causes a warning on agentd start [\#80](https://github.com/voxpupuli/puppet-zabbix/issues/80)
- Debian repo key cannot be validated by apt module [\#78](https://github.com/voxpupuli/puppet-zabbix/issues/78)

**Merged pull requests:**

- Added zabbix\_hostgroup [\#87](https://github.com/voxpupuli/puppet-zabbix/pull/87) ([hkumarmk](https://github.com/hkumarmk))
- Fixes \#80 setting Hostname and HostnameItem causes a warning on agentd s... [\#82](https://github.com/voxpupuli/puppet-zabbix/pull/82) ([f0](https://github.com/f0))
- Fix illegal comma separated argument list [\#81](https://github.com/voxpupuli/puppet-zabbix/pull/81) ([IceBear2k](https://github.com/IceBear2k))
- Allow to not purge include dir.  [\#79](https://github.com/voxpupuli/puppet-zabbix/pull/79) ([altvnk](https://github.com/altvnk))
- Correct typo in 'manage\_resources' documentation. [\#77](https://github.com/voxpupuli/puppet-zabbix/pull/77) ([rnelson0](https://github.com/rnelson0))

## [1.3.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.3.0) (2015-04-08)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.2.0...1.3.0)

**Fixed bugs:**

- Multi-node Setup: Web class does not properly configure database port [\#69](https://github.com/voxpupuli/puppet-zabbix/issues/69)
- Apt-key error in Ubuntu 14.04 [\#61](https://github.com/voxpupuli/puppet-zabbix/issues/61)

**Closed issues:**

- You can not configure hostname in zabbix::proxy [\#59](https://github.com/voxpupuli/puppet-zabbix/issues/59)
- Multi-node setup: manage\_resources invalid on Class\[Zabbix::Server\] [\#70](https://github.com/voxpupuli/puppet-zabbix/issues/70)

**Merged pull requests:**

- better default parameter for userparameter [\#73](https://github.com/voxpupuli/puppet-zabbix/pull/73) ([sbaryakov](https://github.com/sbaryakov))
- Fixed small error regarding manage\_resources and it's usage with classes [\#71](https://github.com/voxpupuli/puppet-zabbix/pull/71) ([elricsfate](https://github.com/elricsfate))
- bugfix for vhosts in apache 2.4 [\#67](https://github.com/voxpupuli/puppet-zabbix/pull/67) ([ju5t](https://github.com/ju5t))
- Update apt key to full 40characters [\#66](https://github.com/voxpupuli/puppet-zabbix/pull/66) ([exptom](https://github.com/exptom))
- rename ListenIp =\> ListenIP [\#65](https://github.com/voxpupuli/puppet-zabbix/pull/65) ([sbaryakov](https://github.com/sbaryakov))
- Fix manage\_repo parameter on the zabbix class [\#63](https://github.com/voxpupuli/puppet-zabbix/pull/63) ([roidelapluie](https://github.com/roidelapluie))
- minor typo [\#60](https://github.com/voxpupuli/puppet-zabbix/pull/60) ([andresvia](https://github.com/andresvia))
- Fix with previous fix with listenip [\#58](https://github.com/voxpupuli/puppet-zabbix/pull/58) ([meganuke19](https://github.com/meganuke19))

## [1.2.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.2.0) (2015-02-26)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.1.0...1.2.0)

**Implemented enhancements:**

- allow setting location of psql [\#44](https://github.com/voxpupuli/puppet-zabbix/issues/44)

**Fixed bugs:**

- failure if zabbix hostgroup does not exist [\#41](https://github.com/voxpupuli/puppet-zabbix/issues/41)
- Bad syntax in manifests/proxy.pp [\#50](https://github.com/voxpupuli/puppet-zabbix/issues/50)
- listenip bug [\#49](https://github.com/voxpupuli/puppet-zabbix/issues/49)

**Closed issues:**

- When using SSL, the root is not rewritten to SSL [\#47](https://github.com/voxpupuli/puppet-zabbix/issues/47)

**Merged pull requests:**

- Fixed bug with listenip & add lxc interface [\#46](https://github.com/voxpupuli/puppet-zabbix/pull/46) ([meganuke19](https://github.com/meganuke19))
- notify zabbix-agent service when userparameters change [\#57](https://github.com/voxpupuli/puppet-zabbix/pull/57) ([rleemorlang](https://github.com/rleemorlang))
- Fix in params.pp with default parameter of zabbix proxy for ubuntu [\#56](https://github.com/voxpupuli/puppet-zabbix/pull/56) ([fredprod](https://github.com/fredprod))
- Jvd w fix defined [\#53](https://github.com/voxpupuli/puppet-zabbix/pull/53) ([JvdW](https://github.com/JvdW))
- Fix agent listenip [\#52](https://github.com/voxpupuli/puppet-zabbix/pull/52) ([JvdW](https://github.com/JvdW))
- line 350 modify casesize to cachesize \#50 [\#51](https://github.com/voxpupuli/puppet-zabbix/pull/51) ([fredprod](https://github.com/fredprod))
- Correctly rewrite the root when using SSL, fixes \#47 [\#48](https://github.com/voxpupuli/puppet-zabbix/pull/48) ([slyoldfox](https://github.com/slyoldfox))

## [1.1.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.1.0) (2015-01-24)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.0.1...1.1.0)

**Closed issues:**

- manage\_repo false still installs repo [\#43](https://github.com/voxpupuli/puppet-zabbix/issues/43)
- Unable to create host with zabbixapi - Invalid params [\#37](https://github.com/voxpupuli/puppet-zabbix/issues/37)

**Merged pull requests:**

- This resolves dj-wasabi/puppet-zabbix\#37. [\#40](https://github.com/voxpupuli/puppet-zabbix/pull/40) ([genebean](https://github.com/genebean))
- Fix name of agent config file in params.pp [\#39](https://github.com/voxpupuli/puppet-zabbix/pull/39) ([mmerfort](https://github.com/mmerfort))
- setting manage\_repo to false breaks server install [\#38](https://github.com/voxpupuli/puppet-zabbix/pull/38) ([genebean](https://github.com/genebean))

## [1.0.1](https://github.com/voxpupuli/puppet-zabbix/tree/1.0.1) (2015-01-12)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/1.0.0...1.0.1)

**Fixed bugs:**

- Module fails with future parser enabled [\#29](https://github.com/voxpupuli/puppet-zabbix/issues/29)

**Merged pull requests:**

- allow custom  owner and group for zabbix server config, [\#36](https://github.com/voxpupuli/puppet-zabbix/pull/36) ([f0](https://github.com/f0))
- ZABBIX proxy and ZABBIX server service names are now customizable / Allow changing the path to the database schema files [\#35](https://github.com/voxpupuli/puppet-zabbix/pull/35) ([f0](https://github.com/f0))
- remove hardcoded config file paths for server, proxy and agent [\#34](https://github.com/voxpupuli/puppet-zabbix/pull/34) ([f0](https://github.com/f0))

## [1.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/1.0.0) (2015-01-02)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.6.1...1.0.0)

**Implemented enhancements:**

- Split Zabbix Server Class into Components [\#11](https://github.com/voxpupuli/puppet-zabbix/issues/11)

**Fixed bugs:**

- zabbixapi gem fails to install \(ubuntu 14.04\) [\#16](https://github.com/voxpupuli/puppet-zabbix/issues/16)

**Closed issues:**

- Update apache\_ssl\_cipher list [\#31](https://github.com/voxpupuli/puppet-zabbix/issues/31)
- Wrong fping path on Ubuntu 14.04 [\#28](https://github.com/voxpupuli/puppet-zabbix/issues/28)

**Merged pull requests:**

- Update  apache\_ssl\_cipher  list [\#32](https://github.com/voxpupuli/puppet-zabbix/pull/32) ([karolisc](https://github.com/karolisc))
- Add support for debian sid \(just use wheezy package\) [\#30](https://github.com/voxpupuli/puppet-zabbix/pull/30) ([lucas42](https://github.com/lucas42))
- Add support for low level discovery\(LLD\) scripts [\#27](https://github.com/voxpupuli/puppet-zabbix/pull/27) ([karolisc](https://github.com/karolisc))
- Remove execute bit from .conf files [\#26](https://github.com/voxpupuli/puppet-zabbix/pull/26) ([karolisc](https://github.com/karolisc))
- Wrong name in zabbix::userparameters resource example. [\#25](https://github.com/voxpupuli/puppet-zabbix/pull/25) ([karolisc](https://github.com/karolisc))

## [0.6.1](https://github.com/voxpupuli/puppet-zabbix/tree/0.6.1) (2014-12-09)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.6.0...0.6.1)

**Closed issues:**

- Module expects postgresql to be install on same machine [\#18](https://github.com/voxpupuli/puppet-zabbix/issues/18)
- Firewall and server domain name [\#17](https://github.com/voxpupuli/puppet-zabbix/issues/17)

**Merged pull requests:**

- Add repository for debian running on a raspberry pi [\#23](https://github.com/voxpupuli/puppet-zabbix/pull/23) ([lucas42](https://github.com/lucas42))
- Install packages needed for the zabbixapi gem to be installed on Debain [\#21](https://github.com/voxpupuli/puppet-zabbix/pull/21) ([lucas42](https://github.com/lucas42))

## [0.6.0](https://github.com/voxpupuli/puppet-zabbix/tree/0.6.0) (2014-12-06)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.5.1...0.6.0)

**Closed issues:**

- Incorrectly initiated mysql/postgresql server class [\#14](https://github.com/voxpupuli/puppet-zabbix/issues/14)
- Wrong mpm, missing php module on ubuntu 14.04 [\#13](https://github.com/voxpupuli/puppet-zabbix/issues/13)

**Merged pull requests:**

- Don't assume db\_host will be localhost in postgresql.pp [\#20](https://github.com/voxpupuli/puppet-zabbix/pull/20) ([lucas42](https://github.com/lucas42))
- Adding support for sqlite [\#15](https://github.com/voxpupuli/puppet-zabbix/pull/15) ([actionjack](https://github.com/actionjack))

## [0.5.1](https://github.com/voxpupuli/puppet-zabbix/tree/0.5.1) (2014-10-30)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.5.0...0.5.1)

**Closed issues:**

- zabbix.conf.php.erb wrong zbx name [\#9](https://github.com/voxpupuli/puppet-zabbix/issues/9)
- Add support for SSL sites [\#8](https://github.com/voxpupuli/puppet-zabbix/issues/8)

**Merged pull requests:**

- fix for host template management [\#12](https://github.com/voxpupuli/puppet-zabbix/pull/12) ([nburtsev](https://github.com/nburtsev))

## [0.5.0](https://github.com/voxpupuli/puppet-zabbix/tree/0.5.0) (2014-10-11)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.4.1...0.5.0)

**Closed issues:**

- module installation fails [\#7](https://github.com/voxpupuli/puppet-zabbix/issues/7)
- Using zabbix-server with theforeman [\#1](https://github.com/voxpupuli/puppet-zabbix/issues/1)

## [0.4.1](https://github.com/voxpupuli/puppet-zabbix/tree/0.4.1) (2014-09-11)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.4.0...0.4.1)

**Closed issues:**

- Support sqLite db for proxies [\#6](https://github.com/voxpupuli/puppet-zabbix/issues/6)

## [0.4.0](https://github.com/voxpupuli/puppet-zabbix/tree/0.4.0) (2014-08-22)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.3.1...0.4.0)

## [0.3.1](https://github.com/voxpupuli/puppet-zabbix/tree/0.3.1) (2014-08-01)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.3.0...0.3.1)

## [0.3.0](https://github.com/voxpupuli/puppet-zabbix/tree/0.3.0) (2014-07-19)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.1.0...0.3.0)

**Closed issues:**

- how use zabbix::userparams ? [\#2](https://github.com/voxpupuli/puppet-zabbix/issues/2)

**Merged pull requests:**

- Added XenServer 6.2 support [\#5](https://github.com/voxpupuli/puppet-zabbix/pull/5) ([sq4ind](https://github.com/sq4ind))
- added support for Scientific Linux [\#4](https://github.com/voxpupuli/puppet-zabbix/pull/4) ([gattebury](https://github.com/gattebury))
- fixes for usage of params and dependecy cycles [\#3](https://github.com/voxpupuli/puppet-zabbix/pull/3) ([maciejstromich](https://github.com/maciejstromich))

## [0.1.0](https://github.com/voxpupuli/puppet-zabbix/tree/0.1.0) (2014-04-17)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.0.3...0.1.0)

## [0.0.3](https://github.com/voxpupuli/puppet-zabbix/tree/0.0.3) (2014-03-31)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.0.2...0.0.3)

## [0.0.2](https://github.com/voxpupuli/puppet-zabbix/tree/0.0.2) (2014-03-28)
[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/voxpupuli/puppet-zabbix/tree/0.0.1) (2014-03-18)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*