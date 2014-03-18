#puppet-zabbix

##Description

This module contains the classes for installing the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy

##How to use:
You can configure the zabbix-server and zabbix-proxy to manage their databases. For now it is only Postgresql databases. It will create an Postgres database, username with an password and will load the zabbix install file(s). In the near future, Mysql and sqlite will be included as well.
###Installing the zabbix-server
```ruby
class { 'zabbix::server':
}
```

###Installing the zabbix-agent
```ruby
class { 'zabbix::agent':
  server => '192.168.1.1',
}
```

###Installing the zabbix-proxy
```ruby
class { 'zabbix::proxy':
  zabbix_server_host => '192.168.1.1',
  zabbix_server_port => '10051',
}
```

###Using zabbix::userparameters:
You can use userparameter files (or specific entries) to install it into the agent.

```ruby
zabbix::userparameters { 'mysql.conf':
  source => 'puppet:///modules/zabbix/mysqld.conf',
}
```

##Todo:
The following is an overview of todo actions:

  - Postgresql is only configured yet, need to create databases for MySQL and Sqlite
  - Add parameter for manage_firewall and create if needed firewall rules.
  - Add vhost for zabbix-web package.
  - Create zabbix-javagateway class
  - Create tests.
  - Support for other linux systems?

##Note
This module is only tested on RHEL systems.