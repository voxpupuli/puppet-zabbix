# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v8.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v8.0.0) (2020-02-01)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v7.0.0...v8.0.0)

**Breaking changes:**

- Implement self.prefetch for zabbix\_proxy [\#642](https://github.com/voxpupuli/puppet-zabbix/pull/642) ([baurmatt](https://github.com/baurmatt))

**Implemented enhancements:**

- Allow to delete a zabbix\_proxy [\#653](https://github.com/voxpupuli/puppet-zabbix/pull/653) ([baurmatt](https://github.com/baurmatt))
- Add logtype parameter for zabbix server \(issue \#394\) [\#650](https://github.com/voxpupuli/puppet-zabbix/pull/650) ([dpavlotzky](https://github.com/dpavlotzky))
- Add zabbix.com repository for Raspbian Linux [\#648](https://github.com/voxpupuli/puppet-zabbix/pull/648) ([emetriqChris](https://github.com/emetriqChris))
- Explicitly use 'ensure =\> file' for normal file resources [\#626](https://github.com/voxpupuli/puppet-zabbix/pull/626) ([baurmatt](https://github.com/baurmatt))

**Closed issues:**

- Test for CentOS 7 current failing due to bug in docker [\#645](https://github.com/voxpupuli/puppet-zabbix/issues/645)
- Service started before database is required [\#632](https://github.com/voxpupuli/puppet-zabbix/issues/632)
- Place agent config file if config file is a symlink [\#625](https://github.com/voxpupuli/puppet-zabbix/issues/625)

**Merged pull requests:**

- update repo links to https [\#652](https://github.com/voxpupuli/puppet-zabbix/pull/652) ([bastelfreak](https://github.com/bastelfreak))
- Make the tablespace parameter available in the zabbix class. [\#651](https://github.com/voxpupuli/puppet-zabbix/pull/651) ([dpavlotzky](https://github.com/dpavlotzky))
- Add tablespace parameter [\#649](https://github.com/voxpupuli/puppet-zabbix/pull/649) ([dpavlotzky](https://github.com/dpavlotzky))
- Pin CentOS acceptance tests 7.6.1810 [\#646](https://github.com/voxpupuli/puppet-zabbix/pull/646) ([baurmatt](https://github.com/baurmatt))
- Remove duplicate CONTRIBUTING.md file [\#641](https://github.com/voxpupuli/puppet-zabbix/pull/641) ([dhoppe](https://github.com/dhoppe))
- drop Ubuntu 14.04 support [\#639](https://github.com/voxpupuli/puppet-zabbix/pull/639) ([bastelfreak](https://github.com/bastelfreak))
- add 'VirtuozzoLinux' support [\#635](https://github.com/voxpupuli/puppet-zabbix/pull/635) ([kBite](https://github.com/kBite))

## [v7.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v7.0.0) (2019-10-06)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.7.0...v7.0.0)

**Breaking changes:**

- drop legacy puppetlabs/pe\_gem dependency & cleanup code [\#628](https://github.com/voxpupuli/puppet-zabbix/pull/628) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppetlabs/apache 5.x, puppetlabs/concat 6.x, puppetlabs/firewall 2.x, puppetlabs/mysql 9.x, puppetlabs/stdlib 6.x; drop puppetlabs/ruby dependency [\#610](https://github.com/voxpupuli/puppet-zabbix/pull/610) ([dhoppe](https://github.com/dhoppe))
- modulesync 2.5.1 and drop Puppet 4 [\#589](https://github.com/voxpupuli/puppet-zabbix/pull/589) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add historyindexcachesize to class zabbix [\#566](https://github.com/voxpupuli/puppet-zabbix/issues/566)
- Add support for specifying unsupported repo location. [\#612](https://github.com/voxpupuli/puppet-zabbix/pull/612) ([jadestorm](https://github.com/jadestorm))
- Put selboolean{'zabbix\_can\_network'} inside ensure\_resources [\#599](https://github.com/voxpupuli/puppet-zabbix/pull/599) ([KrzysztofHajdamowicz](https://github.com/KrzysztofHajdamowicz))
- Implement self.prefetch for zabbix\_host [\#591](https://github.com/voxpupuli/puppet-zabbix/pull/591) ([baurmatt](https://github.com/baurmatt))
- Added historyindexcachesize to class zabbix \(part2\) [\#586](https://github.com/voxpupuli/puppet-zabbix/pull/586) ([Ordnaxz](https://github.com/Ordnaxz))
- Add Remote Commands capabilities on Zabbix Proxy [\#575](https://github.com/voxpupuli/puppet-zabbix/pull/575) ([Safranil](https://github.com/Safranil))

**Fixed bugs:**

- PrivateDevices=yes stops fping from working on Ubuntu 18.04 [\#609](https://github.com/voxpupuli/puppet-zabbix/issues/609)
- zabbix::userparameters::data doesn't notify correctly the zabbix-agent service [\#607](https://github.com/voxpupuli/puppet-zabbix/issues/607)
- puppetlabs/mysql: allow 10.x & zabbix-server: start service after initfile is created [\#624](https://github.com/voxpupuli/puppet-zabbix/pull/624) ([bastelfreak](https://github.com/bastelfreak))
- Delete PrivateDevices attribute in systemd service template file [\#618](https://github.com/voxpupuli/puppet-zabbix/pull/618) ([jordips](https://github.com/jordips))
- Fix minor typo in agent\_servicename param [\#616](https://github.com/voxpupuli/puppet-zabbix/pull/616) ([ljeromets](https://github.com/ljeromets))

**Closed issues:**

- Cannot declare Selboolean zabbix\_can\_network elsewhere [\#598](https://github.com/voxpupuli/puppet-zabbix/issues/598)
- check\_template\_in\_host function missing parameter [\#594](https://github.com/voxpupuli/puppet-zabbix/issues/594)
- Fails to apply manifest for zabbix-agent 3.0 [\#590](https://github.com/voxpupuli/puppet-zabbix/issues/590)
- zabbix 3.0 vs php version  [\#429](https://github.com/voxpupuli/puppet-zabbix/issues/429)

**Merged pull requests:**

- add `managed by puppet` header to unit files [\#615](https://github.com/voxpupuli/puppet-zabbix/pull/615) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppet-selinux 3.x [\#613](https://github.com/voxpupuli/puppet-zabbix/pull/613) ([ekohl](https://github.com/ekohl))
- Allow puppetlabs/apache 4.x, puppetlabs/apt 7.x, puppetlabs/postgresql 6.x [\#605](https://github.com/voxpupuli/puppet-zabbix/pull/605) ([dhoppe](https://github.com/dhoppe))
- Fix check\_template\_in\_host function missing parameter [\#595](https://github.com/voxpupuli/puppet-zabbix/pull/595) ([fgallese](https://github.com/fgallese))
- Implement self.prefetch for zabbix\_hostgroup [\#593](https://github.com/voxpupuli/puppet-zabbix/pull/593) ([baurmatt](https://github.com/baurmatt))
- switch acceptance tests from trusty to xenial [\#585](https://github.com/voxpupuli/puppet-zabbix/pull/585) ([bastelfreak](https://github.com/bastelfreak))
- Allow puppetlabs-mysql 7.x [\#584](https://github.com/voxpupuli/puppet-zabbix/pull/584) ([ekohl](https://github.com/ekohl))
- update travis distro from trusty to xenial [\#582](https://github.com/voxpupuli/puppet-zabbix/pull/582) ([bastelfreak](https://github.com/bastelfreak))
- Feature/userparameters ensure [\#581](https://github.com/voxpupuli/puppet-zabbix/pull/581) ([baurmatt](https://github.com/baurmatt))
- Move api configuration to a config file [\#579](https://github.com/voxpupuli/puppet-zabbix/pull/579) ([baurmatt](https://github.com/baurmatt))

## [v6.7.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.7.0) (2018-12-21)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.6.0...v6.7.0)

**Implemented enhancements:**

- Add Zabbix 3.4 and 4.0 support [\#577](https://github.com/voxpupuli/puppet-zabbix/pull/577) ([gdubicki](https://github.com/gdubicki))
- Add ability to stop the agent [\#562](https://github.com/voxpupuli/puppet-zabbix/pull/562) ([mkilchhofer](https://github.com/mkilchhofer))
- Make repo\_location usable [\#538](https://github.com/voxpupuli/puppet-zabbix/pull/538) ([baurmatt](https://github.com/baurmatt))

**Fixed bugs:**

- zabbix\_template resource doesn't work with Zabbix 4.0 [\#556](https://github.com/voxpupuli/puppet-zabbix/issues/556)
- Properly require zabbixapi gem [\#572](https://github.com/voxpupuli/puppet-zabbix/pull/572) ([baurmatt](https://github.com/baurmatt))
- Add zabbix\_package\_state to the zabbix class to allow upgrade of se… [\#568](https://github.com/voxpupuli/puppet-zabbix/pull/568) ([r-catania](https://github.com/r-catania))

**Closed issues:**

- Incompatibility with puppetlabs-apt \(starting from 6.1.0 version \) [\#569](https://github.com/voxpupuli/puppet-zabbix/issues/569)
- Make zabbix::resources::agent::hostname configurable in zabbix::agent [\#563](https://github.com/voxpupuli/puppet-zabbix/issues/563)
- Drop management of Init script [\#541](https://github.com/voxpupuli/puppet-zabbix/issues/541)
- zabbix::userparameters has to require zabbix::agent [\#539](https://github.com/voxpupuli/puppet-zabbix/issues/539)
- zabbix::repo::repo\_location isn't used [\#537](https://github.com/voxpupuli/puppet-zabbix/issues/537)
- Make types run in puppet 4 [\#182](https://github.com/voxpupuli/puppet-zabbix/issues/182)

**Merged pull requests:**

- Fix rspec tests for Gentoo [\#576](https://github.com/voxpupuli/puppet-zabbix/pull/576) ([baurmatt](https://github.com/baurmatt))
- Feature/acceptance test custom types [\#573](https://github.com/voxpupuli/puppet-zabbix/pull/573) ([baurmatt](https://github.com/baurmatt))
- Add data types for zabbix::userparameters [\#565](https://github.com/voxpupuli/puppet-zabbix/pull/565) ([baurmatt](https://github.com/baurmatt))
- Make hostname within exported resources configurable [\#564](https://github.com/voxpupuli/puppet-zabbix/pull/564) ([baurmatt](https://github.com/baurmatt))
- Add manage\_init\_script parameter [\#553](https://github.com/voxpupuli/puppet-zabbix/pull/553) ([baurmatt](https://github.com/baurmatt))
- Include zabbix::agent for better relationship ordering [\#540](https://github.com/voxpupuli/puppet-zabbix/pull/540) ([baurmatt](https://github.com/baurmatt))

## [v6.6.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.6.0) (2018-11-02)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.5.0...v6.6.0)

**Implemented enhancements:**

- Add ldap reqcert [\#560](https://github.com/voxpupuli/puppet-zabbix/pull/560) ([bastelfreak](https://github.com/bastelfreak))
- Improve performance of zabbix\_host [\#559](https://github.com/voxpupuli/puppet-zabbix/pull/559) ([baurmatt](https://github.com/baurmatt))

**Closed issues:**

- Improve performance of zabbix\_host [\#558](https://github.com/voxpupuli/puppet-zabbix/issues/558)
- Feature Request: ProxyOfflineBuffer setting for zabbix proxies missing [\#554](https://github.com/voxpupuli/puppet-zabbix/issues/554)

**Merged pull requests:**

- Fix tests by adding missing `operatingsystem` fact [\#557](https://github.com/voxpupuli/puppet-zabbix/pull/557) ([alexjfisher](https://github.com/alexjfisher))
- Replace is\_ip\_address with Puppet 4 native comparision [\#555](https://github.com/voxpupuli/puppet-zabbix/pull/555) ([baurmatt](https://github.com/baurmatt))
- Fix proxy documentation [\#552](https://github.com/voxpupuli/puppet-zabbix/pull/552) ([frenchtoasters](https://github.com/frenchtoasters))

## [v6.5.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.5.0) (2018-10-17)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.4.2...v6.5.0)

**Implemented enhancements:**

- Add Zabbix 4.0 compatibility and new `config_mode` parameter [\#548](https://github.com/voxpupuli/puppet-zabbix/pull/548) ([Lord-Y](https://github.com/Lord-Y))
- Gentoo service fix [\#545](https://github.com/voxpupuli/puppet-zabbix/pull/545) ([lordievader](https://github.com/lordievader))
- Add Gentoo support [\#535](https://github.com/voxpupuli/puppet-zabbix/pull/535) ([lordievader](https://github.com/lordievader))

**Closed issues:**

- Module cannot install puppetlabs-mysql dependency [\#536](https://github.com/voxpupuli/puppet-zabbix/issues/536)
- Running the puppet-zabbix module on Gentoo gives an ExecutionFailure [\#531](https://github.com/voxpupuli/puppet-zabbix/issues/531)
- The topic is wrong! [\#517](https://github.com/voxpupuli/puppet-zabbix/issues/517)

**Merged pull requests:**

- fix wrong version schema in metadata.json [\#547](https://github.com/voxpupuli/puppet-zabbix/pull/547) ([bastelfreak](https://github.com/bastelfreak))
- Add Puppet 6.x support [\#542](https://github.com/voxpupuli/puppet-zabbix/pull/542) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x, puppetlabs/apt 6.x and puppetlabs/concat 5.x [\#530](https://github.com/voxpupuli/puppet-zabbix/pull/530) ([bastelfreak](https://github.com/bastelfreak))

## [v6.4.2](https://github.com/voxpupuli/puppet-zabbix/tree/v6.4.2) (2018-08-20)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.4.1...v6.4.2)

**Fixed bugs:**

- Fix missing $ in repo definition for Debian sid [\#528](https://github.com/voxpupuli/puppet-zabbix/pull/528) ([isbear](https://github.com/isbear))

## [v6.4.1](https://github.com/voxpupuli/puppet-zabbix/tree/v6.4.1) (2018-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.4.0...v6.4.1)

**Merged pull requests:**

- fix beaker support [\#524](https://github.com/voxpupuli/puppet-zabbix/pull/524) ([bastelfreak](https://github.com/bastelfreak))
- install beaker-rspec 6 or newer [\#523](https://github.com/voxpupuli/puppet-zabbix/pull/523) ([bastelfreak](https://github.com/bastelfreak))
- Add support for latest puppetlabs/{apt,apache/mysql} modules [\#519](https://github.com/voxpupuli/puppet-zabbix/pull/519) ([bastelfreak](https://github.com/bastelfreak))

## [v6.4.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.4.0) (2018-08-05)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.3.2...v6.4.0)

**Implemented enhancements:**

- Expose server name in main class, fixes \#510 [\#511](https://github.com/voxpupuli/puppet-zabbix/pull/511) ([lordievader](https://github.com/lordievader))

**Fixed bugs:**

- Exec\[zabbix\_server\_create.sql\] does not work because is might come after Package\[zabbix-server-mysql [\#505](https://github.com/voxpupuli/puppet-zabbix/issues/505)
- Add missing enable =\> true for zabbix-java-gateway [\#516](https://github.com/voxpupuli/puppet-zabbix/pull/516) ([stefanandres](https://github.com/stefanandres))

**Closed issues:**

- Expose the $zabbix\_server\_name variable [\#510](https://github.com/voxpupuli/puppet-zabbix/issues/510)

**Merged pull requests:**

- get rid of useless topscope calling [\#509](https://github.com/voxpupuli/puppet-zabbix/pull/509) ([bastelfreak](https://github.com/bastelfreak))

## [v6.3.2](https://github.com/voxpupuli/puppet-zabbix/tree/v6.3.2) (2018-06-21)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.3.1...v6.3.2)

**Fixed bugs:**

- Zabbix Repository \(zabbix-non-supported\) defined with incorrect gpgkey [\#397](https://github.com/voxpupuli/puppet-zabbix/issues/397)
- Clarify dependency for database handling [\#508](https://github.com/voxpupuli/puppet-zabbix/pull/508) ([stefanandres](https://github.com/stefanandres))
- Fix missing enable attribut for zabbix::proxy service [\#507](https://github.com/voxpupuli/puppet-zabbix/pull/507) ([stefanandres](https://github.com/stefanandres))
- Support SSL parameters for web monitoring in all versions \>= 2.4 [\#469](https://github.com/voxpupuli/puppet-zabbix/pull/469) ([anotherfigo](https://github.com/anotherfigo))
- wait for network connectivity before Zabbix Server startup [\#454](https://github.com/voxpupuli/puppet-zabbix/pull/454) ([tequeter](https://github.com/tequeter))

**Closed issues:**

- Puppet 5.3 Zabbix 2.4 json conflict [\#502](https://github.com/voxpupuli/puppet-zabbix/issues/502)
- repeated attempted key import in Ubuntu 18.04 [\#500](https://github.com/voxpupuli/puppet-zabbix/issues/500)
- SELinux blocks httpd from accessing database [\#477](https://github.com/voxpupuli/puppet-zabbix/issues/477)

**Merged pull requests:**

- drop EOL OSs; fix puppet version range [\#501](https://github.com/voxpupuli/puppet-zabbix/pull/501) ([bastelfreak](https://github.com/bastelfreak))
- Rely on beaker-hostgenerator for docker nodesets [\#498](https://github.com/voxpupuli/puppet-zabbix/pull/498) ([ekohl](https://github.com/ekohl))

## [v6.3.1](https://github.com/voxpupuli/puppet-zabbix/tree/v6.3.1) (2018-03-29)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.3.0...v6.3.1)

**Fixed bugs:**

- listenip in agent not resolving to IP address from network interface name [\#493](https://github.com/voxpupuli/puppet-zabbix/issues/493)
- Fix listen\_ip bug and relax interface regex [\#494](https://github.com/voxpupuli/puppet-zabbix/pull/494) ([bastelfreak](https://github.com/bastelfreak))

## [v6.3.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.3.0) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.2.0...v6.3.0)

**Implemented enhancements:**

- zabbix::agent without an IP shouldn't guess the IP [\#473](https://github.com/voxpupuli/puppet-zabbix/issues/473)
- add ability to manage ZBX\_SERVER\_NAME in web class [\#491](https://github.com/voxpupuli/puppet-zabbix/pull/491) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Do not guess ListenIP, fixes \#473, bump stdlib to 4.19.0 [\#487](https://github.com/voxpupuli/puppet-zabbix/pull/487) ([lordievader](https://github.com/lordievader))

**Merged pull requests:**

- bump puppet version dependency to \>= 4.10.0 \< 6.0.0 [\#490](https://github.com/voxpupuli/puppet-zabbix/pull/490) ([bastelfreak](https://github.com/bastelfreak))
- allow camptocamp/systemd 2.X [\#486](https://github.com/voxpupuli/puppet-zabbix/pull/486) ([bastelfreak](https://github.com/bastelfreak))

## [v6.2.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.2.0) (2018-02-13)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.1.0...v6.2.0)

**Implemented enhancements:**

- add vmwaretimeout as possible server-param [\#482](https://github.com/voxpupuli/puppet-zabbix/pull/482) ([b014651](https://github.com/b014651))
- \#476 Pass credentials for HTTP auth [\#479](https://github.com/voxpupuli/puppet-zabbix/pull/479) ([tux-o-matic](https://github.com/tux-o-matic))

**Fixed bugs:**

- Dependencies need update [\#453](https://github.com/voxpupuli/puppet-zabbix/issues/453)
- Fixed versioncmp compare and fixed typo in file zabbix-server-ips.te [\#480](https://github.com/voxpupuli/puppet-zabbix/pull/480) ([Fabian1976](https://github.com/Fabian1976))

**Closed issues:**

- stard "firewalld" [\#478](https://github.com/voxpupuli/puppet-zabbix/issues/478)
- Support HTTP auth for API calls [\#476](https://github.com/voxpupuli/puppet-zabbix/issues/476)

**Merged pull requests:**

- Update module dependencies [\#485](https://github.com/voxpupuli/puppet-zabbix/pull/485) ([alexjfisher](https://github.com/alexjfisher))
- Document needed sebooleans for httpd/zabbix-web [\#481](https://github.com/voxpupuli/puppet-zabbix/pull/481) ([Fabian1976](https://github.com/Fabian1976))

## [v6.1.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.1.0) (2017-12-18)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Using $manage\_service in zabbix::proxy [\#374](https://github.com/voxpupuli/puppet-zabbix/pull/374) ([Samgarr](https://github.com/Samgarr))

**Merged pull requests:**

- Update Debian repository public key ID [\#462](https://github.com/voxpupuli/puppet-zabbix/pull/462) ([sigv](https://github.com/sigv))

## [v6.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v6.0.0) (2017-11-11)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v5.0.1...v6.0.0)

**Breaking changes:**

- upgrade default zabbixapi to 3.2.1 [\#457](https://github.com/voxpupuli/puppet-zabbix/pull/457) ([fraenki](https://github.com/fraenki))

**Implemented enhancements:**

- Add support for templated SE Linux agent module [\#452](https://github.com/voxpupuli/puppet-zabbix/pull/452) ([tux-o-matic](https://github.com/tux-o-matic))
- Support multiple zabbix\_alias [\#435](https://github.com/voxpupuli/puppet-zabbix/pull/435) ([fribergr](https://github.com/fribergr))

**Closed issues:**

- Incorrect public key for repository [\#461](https://github.com/voxpupuli/puppet-zabbix/issues/461)
- Allow external script execution with SE Linux [\#441](https://github.com/voxpupuli/puppet-zabbix/issues/441)
- Using existing mysql database [\#237](https://github.com/voxpupuli/puppet-zabbix/issues/237)
- Setting Apache alias /zabbix [\#236](https://github.com/voxpupuli/puppet-zabbix/issues/236)

## [v5.0.1](https://github.com/voxpupuli/puppet-zabbix/tree/v5.0.1) (2017-10-21)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- add selinux workaround for IPC in zabbix-server3.4 [\#459](https://github.com/voxpupuli/puppet-zabbix/pull/459) ([bastelfreak](https://github.com/bastelfreak))
- Remove updateExisting from applications in zabbix template provider. [\#450](https://github.com/voxpupuli/puppet-zabbix/pull/450) ([ghost](https://github.com/ghost))
- Add missing proxy\_mode variable to zabbix\_proxy provider [\#447](https://github.com/voxpupuli/puppet-zabbix/pull/447) ([ghost](https://github.com/ghost))

**Closed issues:**

- Zabbix API errors when adding Templates in Zabbix 3.4 v2 [\#449](https://github.com/voxpupuli/puppet-zabbix/issues/449)
- Zabbix API errors when adding Templates in Zabbix 3.4 [\#446](https://github.com/voxpupuli/puppet-zabbix/issues/446)
- SenderFrequency parameter is deprecated in Zabbix 3.4 [\#437](https://github.com/voxpupuli/puppet-zabbix/issues/437)

**Merged pull requests:**

- Changed image to images in template provider. [\#448](https://github.com/voxpupuli/puppet-zabbix/pull/448) ([ghost](https://github.com/ghost))

## [v5.0.0](https://github.com/voxpupuli/puppet-zabbix/tree/v5.0.0) (2017-09-17)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.1.3...v5.0.0)

**Breaking changes:**

- BREAKING: Bump default zabbix version to 3.4 + test on it [\#443](https://github.com/voxpupuli/puppet-zabbix/pull/443) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Fix for Zabbix 3.4 [\#436](https://github.com/voxpupuli/puppet-zabbix/pull/436) ([Menollo](https://github.com/Menollo))
- Update testmatrix to puppet5 + new gems [\#430](https://github.com/voxpupuli/puppet-zabbix/pull/430) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- override database\_schema\_path for AWS ami instance [\#428](https://github.com/voxpupuli/puppet-zabbix/issues/428)
- Syntax Error at line 82 in file init.pp [\#423](https://github.com/voxpupuli/puppet-zabbix/issues/423)
- pg\_hba problems in zabbix::database [\#411](https://github.com/voxpupuli/puppet-zabbix/issues/411)

**Merged pull requests:**

- release 5.0.0 [\#444](https://github.com/voxpupuli/puppet-zabbix/pull/444) ([bastelfreak](https://github.com/bastelfreak))

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

## [v4.1.1](https://github.com/voxpupuli/puppet-zabbix/tree/v4.1.1) (2017-06-14)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v4.1.0...v4.1.1)

**Fixed bugs:**

- unless $manage\_database interprets False wrong; and useless require breaks standalone database setups [\#409](https://github.com/voxpupuli/puppet-zabbix/pull/409) ([bastelfreak](https://github.com/bastelfreak))

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

**Breaking changes:**

- BREAKING: Add acceptance tests + multiple bugfixes [\#382](https://github.com/voxpupuli/puppet-zabbix/pull/382) ([bastelfreak](https://github.com/bastelfreak))

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

- Change minimum required Puppet version to 4.6.1.  Puppet 3 is no longer supported. [\#345](https://github.com/voxpupuli/puppet-zabbix/pull/345) ([bastelfreak](https://github.com/bastelfreak))

## [v2.6.2](https://github.com/voxpupuli/puppet-zabbix/tree/v2.6.2) (2017-01-11)

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/v2.6.1...v2.6.2)

**Closed issues:**

- Installing on 2 nodes does not setup the database [\#333](https://github.com/voxpupuli/puppet-zabbix/issues/333)

**Merged pull requests:**

- Fix failing test due to missing selinux fact [\#332](https://github.com/voxpupuli/puppet-zabbix/pull/332) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Bump min version\_requirement for Puppet + deps [\#331](https://github.com/voxpupuli/puppet-zabbix/pull/331) ([juniorsysadmin](https://github.com/juniorsysadmin))

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
- Feature selinux [\#191](https://github.com/voxpupuli/puppet-zabbix/pull/191) ([bastelfreak](https://github.com/bastelfreak))

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
- Fixed previous error in merge [\#152](https://github.com/voxpupuli/puppet-zabbix/pull/152) ([rtizzy](https://github.com/rtizzy))
- Added support for adding LDAP certificate location to Zabbix Web. Upd… [\#150](https://github.com/voxpupuli/puppet-zabbix/pull/150) ([rtizzy](https://github.com/rtizzy))
- Allow agent\_serveractive value to be blank [\#147](https://github.com/voxpupuli/puppet-zabbix/pull/147) ([ericsysmin](https://github.com/ericsysmin))
- allow serveractive to be optional [\#146](https://github.com/voxpupuli/puppet-zabbix/pull/146) ([ericsysmin](https://github.com/ericsysmin))
- fixed typo for comment mysql [\#145](https://github.com/voxpupuli/puppet-zabbix/pull/145) ([ghost](https://github.com/ghost))
- fixed SSL server template options for 2.2 [\#141](https://github.com/voxpupuli/puppet-zabbix/pull/141) ([IceBear2k](https://github.com/IceBear2k))
- fix syntax error [\#139](https://github.com/voxpupuli/puppet-zabbix/pull/139) ([mkrakowitzer](https://github.com/mkrakowitzer))
- Allow agent to listen on \* [\#138](https://github.com/voxpupuli/puppet-zabbix/pull/138) ([ekohl](https://github.com/ekohl))
- enable apache\_php\_max\_input\_vars [\#137](https://github.com/voxpupuli/puppet-zabbix/pull/137) ([bastelfreak](https://github.com/bastelfreak))
- Fix typo in zabbix-userparameters reference [\#136](https://github.com/voxpupuli/puppet-zabbix/pull/136) ([sgnl05](https://github.com/sgnl05))
- Listen on all IPs [\#133](https://github.com/voxpupuli/puppet-zabbix/pull/133) ([steinbrueckri](https://github.com/steinbrueckri))
- tap0 or tun0 \(OpenVPN interfaces\) interface as listenip [\#132](https://github.com/voxpupuli/puppet-zabbix/pull/132) ([steinbrueckri](https://github.com/steinbrueckri))
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

- Generalise the zabbix\_url [\#129](https://github.com/voxpupuli/puppet-zabbix/pull/129) ([eliranbz](https://github.com/eliranbz))
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
- Added Support For Zapache monitoring script [\#94](https://github.com/voxpupuli/puppet-zabbix/pull/94) ([rtizzy](https://github.com/rtizzy))

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
- Fixed small error regarding manage\_resources and it's usage with classes [\#71](https://github.com/voxpupuli/puppet-zabbix/pull/71) ([rtizzy](https://github.com/rtizzy))
- bugfix for vhosts in apache 2.4 [\#67](https://github.com/voxpupuli/puppet-zabbix/pull/67) ([ju5t](https://github.com/ju5t))
- Update apt key to full 40characters [\#66](https://github.com/voxpupuli/puppet-zabbix/pull/66) ([exptom](https://github.com/exptom))
- rename ListenIp =\> ListenIP [\#65](https://github.com/voxpupuli/puppet-zabbix/pull/65) ([sbaryakov](https://github.com/sbaryakov))
- Fix manage\_repo parameter on the zabbix class [\#63](https://github.com/voxpupuli/puppet-zabbix/pull/63) ([roidelapluie](https://github.com/roidelapluie))
- minor typo [\#60](https://github.com/voxpupuli/puppet-zabbix/pull/60) ([andresvia](https://github.com/andresvia))
- Fix with previous fix with listenip [\#58](https://github.com/voxpupuli/puppet-zabbix/pull/58) ([ghost](https://github.com/ghost))

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

- Fixed bug with listenip & add lxc interface [\#46](https://github.com/voxpupuli/puppet-zabbix/pull/46) ([ghost](https://github.com/ghost))
- notify zabbix-agent service when userparameters change [\#57](https://github.com/voxpupuli/puppet-zabbix/pull/57) ([rmorlang](https://github.com/rmorlang))
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
- Update  apache\_ssl\_cipher  list [\#32](https://github.com/voxpupuli/puppet-zabbix/pull/32) ([karolisc](https://github.com/karolisc))

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

[Full Changelog](https://github.com/voxpupuli/puppet-zabbix/compare/bc293f50f16bafb6c610b6c43f1944a776563008...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
