#wdijkerman-zabbix release

Below an overview of all changes in the releases.

Version (Release date)

1.6.0   (2015-08-21)

  * Pass manage_repo and zabbix_repo to repo.pp and prevent double include #110 (By pull request: mmerfort (Thanks!))
  * Add "eno" to interface name matching #104 (By pull request: sgnl05 (Thanks!))
  * use the new puppetlabs-apt version 2.x module #103 (By pull request: hmn (Thanks!))
  * Fix name startvmwarecollector -> startvmwarecollectors #102 (By pull request: BcTpe4HbIu (Thanks!))
  * Custom apache IP and port #99 (By pull request: mschuett (Thanks!))
  * Feature Request: add charset/collate option during a mysql db resource creation #107
  * Added support Debian 8
  * Fixed some rpsec tests
  * Fixed some puppet-lint identation warnings
  * Updated the zabbixapi gem install with recent versions

1.5.0   (2015-06-08)

  * Fix for: Inherting params #93
  * Fix for: new postgresql instance #91; Also update metadata for postgresl module version
  * Fix for: Need to overide php_values #89
  * 2nd fix for: Zabbix-proxy install database population #62. Also for postgresql now.
  * Added support to Amazon Linux with epel 6. #96 (By pull request: Wprosdocimo (Thanks!))
  * import templates and create hostgroup if missing #95 (By pull request: 1n (Thanks!))
  * Added Support For Zapache monitoring script #94 (By pull request: elricsfate (Thanks!))
  * merge of hiera hashes from entire hierarchy #98 (By pull request: szemlyanoy (Thanks!))
  * Added property script_ext for: File extensions of Userparameters scripts #97
  * Updated documentation in README.md

1.4.0   (2015-05-18)

  * Adding "apt" as dependency.
  * Adding 'script_dir' parameter for userparameters define.
  * Fix documentation: iptables is set to false (not true).
  * Fix illegal comma separated argument list #81 (By pull request: IceBear2k (Thanks!))
  * Fixes #80 setting Hostname and HostnameItem causes a warning on agentd s... #82 (By pull request: f0 (Thanks!))
  * Allow to not purge include dir. #79 (By pull request: altvnk (Thanks!))
  * Correct typo in 'manage_resources' documentation. #77 (By pull request: rnelson0 (Thanks!))
  * Added zabbix_hostgroup #87 (By pull request: hkumarmk (Thanks!))

1.3.0   (2015-04-08)

  * bugfix for vhosts in apache 2.4 #67 (By pull request: ju5t (Thanks!))
  * Update apt key to full 40characters #66 (By pull request: exptom (Thanks!))
  * rename ListenIp => ListenIP (By pull request: sbaryakov (Thanks!))
  * Fix manage_repo parameter on the zabbix class (By pull request: roidelapluie (Thanks!))
  * minor typo (By pull request: andresvia (Thanks!))
  * better default parameter for userparameter (By pull request: sbaryakov (Thanks!))
  * Fix for: Multi-node Setup: Web class does not properly configure database port #69
  * Fix for: Zabbix-proxy install database population #62

1.2.0   (2015-02-26)

  * Support for RedHat/CentOS/OracleLinux 7
  * Fixed bug with listenip & add lxc interface #46 (By pull request: meganuke19 (Thanks!))
  * Bad syntax in manifests/proxy.pp #50 (By pull request: fredprod (Thanks!))
  * Fix agent listenip #52 (By pull request: JvdW (Thanks!))
  * Fix in params.pp with default parameter of zabbix proxy for ubuntu #56 (By pull request: fredprod (Thanks!))
  * notify zabbix-agent service when userparameters change #57 (By pull request: rleemorlang (Thanks!))
  * Fix for: "Cannot Load Such File -- zabbixapi" despite installation #54
  * Fix for: correct order, so 1 puppet run installs the proxy

1.1.0   (2015-01-24)

  * Fix name of agent config file in params.pp #39 (By pull request: mmerfort (Thanks!))
  * Unable to create host with zabbixapi - Invalid params #37 (By pull request: genebean (Thanks!))
  * setting manage_repo to false breaks server install #38 (By pull request: genebean (Thanks!))
  * listenip statement didn't work with 'eth' addresses" manifests/agent.pp
  * Fix for: rpsec tests to work with latest version.
  * Fix for: (mysql and postgresql) must be quotted as it contains special characters
  * Fix for: allow setting location of psql #44
  * Fix: for the last identation error in manifests/web.pp.

1.0.1   (2015-01-12)

  * remove hardcoded config file paths for server, proxy and agent #34 (By pull request: f0 (Thanks!))
  * ZABBIX proxy and ZABBIX server service names are now customizable / Allow changing the path to the database schema files #35 (By pull request: f0 (Thanks!))
  * allow custom owner and group for zabbix server config, #36 (By pull request: f0 (Thanks!))
  * Fixed some puppet-lint messages (Was using old puppet-lint version)

1.0.0   (2015-01-02)

  * Split Zabbix Server Class into Components. See the documentation `readme.md` for more information.
  * Renamed some parameters. Mostly the database parameters, from `db` to `database_`
  * Changed the paths for the <sqlfile>.done files to /etc/zabbix/. This makes upgrading zabbix components a lot easier.
  * Added zabbix_package_state parameter. You can choose present or latest.
  * Included the puppetlabs/ruby for development packages when installing the zabbixapi gem.
  * Add support for low level discovery(LLD) scripts #27 (By pull request: karolisc (Thanks!))
  * Remove execute bit from .conf files #26 (By pull request: karolisc (Thanks!))
  * Wrong name in zabbix::userparameters resource example. #25 (By pull request: karolisc (Thanks!))
  * Fix for: Module fails with future parser enabled #29
  * Fix for: Wrong fping path on Ubuntu 14.04 #28
  * fixed puppet-lint message in userparameter.pp
  * Add support for debian sid (just use wheezy package) #30 (By pull request: lucas42 (Thanks!))
  * Fox for: Update apache_ssl_cipher list #31 (And by pull request: karolisc (Thanks!))

0.6.1   (2014-12-09)

  * Add repository for debian running on a raspberry pi (By pull request: lucas42 (Thanks!))
  * fixed puppet-lint messages

0.6.0   (2014-12-06)

  * Add support for sqlite (by pull request: actionjack (Thanks!))
  * Updated documentation for correct usage server and proxy (Thanks for noticing karolisc!)
  * Don't assume db_host will be localhost in postgresql.pp #20 (By pull request: lucas42 (Thanks!))
  * added class zabbix::userparameter for using userparameters define in Hiera or The Foreman
  * Removed the '/24' in zabbix::agent for firewall.

0.5.1	(2014-10-30)

  * Added apache_ssl_chain as parameter for zabbix::server
  * zabbix.conf.php.erb wrong zbx name (https://github.com/dj-wasabi/puppet-zabbix/issues/9)
  * fix for host template management (Fixed by pull request: burtsev (Thanks!))

0.5.0	(2014-10-11)

  * zabbixapi gem is installed by version.
  * Possibility to create SSL vhost. (As requested: https://github.com/dj-wasabi/puppet-zabbix/issues/8)
  * Removed symlink in spec/fixtures/modules dir and updated .fixtures file for this.


0.4.1   (2014-09-11)

  * Added support van Zabbix 2.4
  * Added Ubuntu 14.04

0.4.0   (2014-08-22)

  * Rewrote the readme.
  * Module can make use of "Exported resources" when `manage_resources` is set to true. The zabbix-server can automatically configure agents and directly monitor the agents. It will make use of the zabbix-api.
  * Also possible for the listenip parameter to specificy an 'eth?|bond?' option. It will find out what ipaddress it is and uses this as the ListenIP in the zabbix configuration file. Can be handy when having multiple network interfaces.

0.3.1  (2014-08-01)

  * Added support for Puppet Enterprise 3.2 and 3.3

0.3.0  (2014-07-19)

  * Added repository for scientific (Thanks to: gattebury)
  * Added repository for Xenserver (Thanks to: sq4ind)

0.2.0  (2014-06-18)

  * Added rspec test for zabbix::agent
  * Added rspec test for zabbix::repo
  * Added rspec test for zabbix::proxy
  * Added rspec test for zabbix::server
  * Added rspec test for zabbix::database{mysql,postgresql}
  * Added rspec test for zabbix::userparameters
  * Added rspec test for zabbix::javagateway
  * zabbix::userparameters fixed via pull request github (By 'suff')  --> Thanks!
  * Removed some documented settings
  * nodeid wasn't working with zabbix_server.conf template

0.1.0  (2014-04-17)

  * Added manage_repo parameter. If set to true, it will install the apt/yum repository.
  * Updated module for support Ubuntu (12.x).
  * Updated module for support Debian (6, 7).
  * Updated module for support Oracle Linux (5, 6).

0.0.3  (2014-03-31)

  * Added parameter: manage_vhost for creating vhost (Default: true)
  * Added parameter: manage_firewall for creating firewall rules
  * Added zabbix::javagateway class for installing the Zabbix Java Gateway
  * Renaming parameters javagateway_host to javagateway and javagateway_port to javagatewayport for zabbix::proxy (Same naming as the zabbix::server).

0.0.2  (2014-03-28)

  * MySQL can be used as database back-end.
  * Services started at boot.
  * Vhost creation, need 1 parameter for zabbix-server: zabbix_url.
  * Updated the readme.md

0.0.1 (2014-03-18)

  * Initial working version. Installing of the 
    * zabbix-server
    * zabbix-agent
    * zabbix-proxy
  * Possibility to add userparameters for the zabbix-agent.
