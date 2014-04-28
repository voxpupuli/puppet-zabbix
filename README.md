#puppet-zabbix

####Table of Contents

1. [Description](#description)
2. [How to use](#how-to-use)
  * [Installing the zabbix-server](#zabbix-server)
  * [Installing the zabbix-agent](#zabbix-agent)
  * [Installing the zabbix-proxy](#zabbix-proxy)
  * [Installing the Java Gateway](#zabbix-javagateway)
  * [zabbix::userparameters, Installing the userparameter files](#userparameters)
3. [OS Support](#support)
4. [Rspec](#rspec)
5. [Todo](#todo)
5. [Note](#note)

##Description

This module contains the classes for installing and configuring the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy
  - zabbix-javagateway

##How to use
###zabbix-server
This will install an basic zabbix-server instance. 

You will need to supply one parameter: zabbix_url. This is the url on which the zabbix instance will be available. In the example below, the zabbix webinterface will be: http://zabbix.example.com. 

```ruby
class { 'zabbix::server':
  zabbix_url => 'zabbix.example.com',
}
```

When installed succesfully, zabbix web interface will be accessable and you can login with the default credentials:

Username: Admin

Password: zabbix

#### manage_database
When the parameter 'manage_database' is set to true (Which is default), it will create the database and loads the sql files. Default the postgresql will be used as backend, mentioned in the params.pp file. You'll have to include the postgresql (or mysql) module yourself, as this module will require it.

###zabbix-agent
This will install the zabbix-agent. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server (or zabbix-proxy if this is used.). Default is 127.0.0.1, which only works for the zabbix agent when installed on the same host as zabbix-server (or zabbix-proxy).

```ruby
class { 'zabbix::agent':
  server => '192.168.1.1',
}
```

###zabbix-proxy
This will install an zabbix-proxy instance. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server. Default is 127.0.0.1, which wouldn't work. Be aware, the zabbix::proxy can't be installed on the same server as zabbix::server. 

```ruby
class { 'zabbix::proxy':
  zabbix_server_host => '192.168.1.1',
  zabbix_server_port => '10051',
}
```

#### manage_database
When the parameter 'manage_database' is set to true (Which is default), it will create the database and loads the sql files. Default the postgresql will be used as backend, mentioned in the params.pp file. You'll have to include the postgresql (or mysql) module yourself, as this module will require it.

###zabbix-javagateway
This will install the zabbix java gataway for checking jmx items. It can run without parameters.

```ruby
class { 'zabbix::javagateway': }
```

When using zabbix::javagateway, you'll need to add the 'javagateway' parameter and assign the correct ip address for the zabbix::server or zabbix::proxy instance.

Usage example for an zabbix::server:

```ruby
class { 'zabbix::server':
  zabbix_url  => 'zabbix.example.com', 
  javagateway => '192.168.1.2',
}
```

Or with an zabbix::proxy:

```ruby
class { 'zabbix::proxy':
  zabbix_server_host => '192.168.1.1', 
  javagateway        => '192.168.1.2',
}
```

###userparameters
You can use userparameter files (or specific entries) to install it into the agent.

Using an 'source' file:

```ruby
zabbix::userparameters { 'mysql.conf':
  source => 'puppet:///modules/zabbix/mysqld.conf',
}
```

Or for example when you have just one entry:

```ruby
zabbix::userparameters { 'mysql.conf':
  content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive',
}
```

##Support
The module is only supported on:

Zabbix 2.2:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 7

Zabbix 2.0:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 6, 7


Zabbix 1.8 isn't supported (yet) with this module. Maybe in the near future.

Ubuntu 10.4 is officially supported by zabbix for Zabbix 2.0. I did have some issues with making it work, probably in a future release it is supported with this module as well.

##Rspec

Currently in progress. At the moment only the agent has an basic rspec test. The rest will be in the near future. The goal is for all rspec test in version 0.2.0.

* agent_spec.rb
* repo_spec.rb
* proxy_spec.rb


##Todo
The following is an overview of todo actions:

  - Create rpsec tests.
  - Better documentation.
  - Use of the zabbix-api:
    - automatically creating hosts in the webinterface
    - automatically assing templates to hosts
 
Please send me suggestions! 


##Note

*	Not specified as required but for working correctly, the epel repository should be available for the 'fping'|'fping6' packages.
*	Make sure you have sudo installed and configured with: !requiretty.