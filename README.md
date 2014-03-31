#puppet-zabbix

####Table of Contents

1. [Description](#description)
2. [How to use](#how-to-use)
  * [Installing the zabbix-server](#zabbix-server)
  * [Installing the zabbix-agent](#zabbix-agent)
  * [Installing the zabbix-proxy](#zabbix-proxy)
  * [zabbix::userparameters, Installing the userparameter files](#userparameters)
3. [Limitations](#limitations)
4. [Todo](#todo)
5. [Note](#note)

##Description

This module contains the classes for installing and configuring the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy

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

Username: admin

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

When using zabbix::javagateway, you'll need to add the 'javagateway' parameter and assign the correct ip address.

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

##Limitations
The module has only been tested on:

  * CentOS 6

It should work on other operating systems of the Red Hat family to.

##Todo
The following is an overview of todo actions:

  - Create rpsec tests.
  - Support for other linux systems.
  - Better documentation.
  - Use of the zabbix-api:
    - automatically creating hosts in the webinterface
    - automatically assing templates to hosts
  - Please send me suggestions! 


##Note
Not specified as required but for working correctly, the epel repository should be available for the 'fping'|'fping6' packages.