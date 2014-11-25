#wdijkerman-zabbix release

Below an overview of all changes in the releases.

Version (Release date)

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
