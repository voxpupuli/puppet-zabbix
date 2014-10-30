#puppet-zabbix

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with the zabbix module](#setup)
 	* [zabbix-server](#setup-zabbix-server)
 	* [zabbix-agent](#setup-zabbix-agent)
 	* [zabbix-proxy](#setup-zabbix-proxy)
 	* [zabbix-javagateway](#setup-zabbix-javagateway)
 	* [zabbix-userparameters](#setup-userparameters)
4. [Usage - Configuration options and additional functionality](#usage)
    * [zabbix-server](#usage-zabbix-server)
    * [zabbix-agent](#usage-zabbix-agent)
    * [zabbix-proxy](#usage-zabbix-proxy)
    * [zabbix-javagateway](#usage-zabbix-javagateway)
    * [zabbix-userparameters](#usage-zabbix-userparameters)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [zabbix-server](#reference-zabbix-server)
    * [zabbix-agent](#reference-zabbix-agent)
    * [zabbix-proxy](#reference-zabbix-proxy)
    * [zabbix-javagateway](#reference-zabbix-javagateway)
    * [zabbix-userparameters](#reference-zabbix-userparameters)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Contributors](#contributors)
8. [Notes](#note)
    * [Some overall notes](#standard-usage)
    * [When using exported resources | manage_resources is true](#when-using-exported-resources)

##Overview

This module contains the classes for installing and configuring the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy
  - zabbix-javagateway

##Module Description
When using this module, you can monitor your whole environment with zabbix. It can install the various zabbix components like the server and agent, but you will also be able to install specific "userparameter" file which zabbix can use for monitoring.  

With the 0.4.0 release, you can - when you have configured exported resources - configure agents and proxies in the webinterface. So when you add an zabbix::agent to an host, it first install the agent onto the host. It will send some data to the puppetdb and when puppet runs on the zabbix-server it will create this new host via the zabbix-api.

Be aware when you have a lot of hosts, it will increase the puppet runtime on the zabbix-server host. It will check via the zabbix-api if hosts exits and costs time. 

This module make uses of this gem: https://github.com/express42/zabbixapi
With this gem it is possible to create/update hosts/proxy in ruby easy. 

##Setup
As this puppet module contains specific components for zabbix, you'll need to specify which you want to install. Every zabbix component has his own zabbix:: class. Here you'll find each component.

###Setup zabbix-server
This will install an basic zabbix-server instance. 

You will need to supply one parameter: zabbix_url. This is the url on which the zabbix instance will be available. With the example at "setup", the zabbix webinterface will be: http://zabbix.example.com. 

When installed succesfully, zabbix web interface will be accessable and you can login with the default credentials:

Username: Admin
Password: zabbix

###Setup zabbix-agent
This will install the zabbix-agent. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server (or zabbix-proxy if this is used.). Default is 127.0.0.1, which only works for the zabbix agent when installed on the same host as zabbix-server (or zabbix-proxy).

###Setup zabbix-proxy
This will install an zabbix-proxy instance. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server. Default is 127.0.0.1, which wouldn't work. Be aware, the zabbix::proxy can't be installed on the same server as zabbix::server.

###Setup zabbix-javagateway
This will install the zabbix java gataway for checking jmx items. It can run without any parameters.

When using zabbix::javagateway, you'll need to add the 'javagateway' parameter and assign the correct ip address for the zabbix::server or zabbix::proxy instance.

###Setup userparameters
You can use userparameter files (or specific entries) to install it into the agent.

##Usage
The following will provide an basic usage of the zabbix components.
###Usage zabbix-server
```ruby
class { 'zabbix::server':
  zabbix_url => 'zabbix.example.com',
}
```

###Usage zabbix-agent
```ruby
class { 'zabbix::agent':
  server => '192.168.1.1',
}
```

###Usage zabbix-proxy

```ruby
class { 'zabbix::proxy':
  zabbix_server_host => '192.168.1.1',
  zabbix_server_port => '10051',
}
```
###Usage zabbix-javagateway

```ruby
class { 'zabbix::javagateway': }
```

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
###Usage zabbix-userparameters
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

##Reference
There are some overall parameters which exists on the classes (zabbix::server, zabbix::proxy, zabbix::agent & zabbix::javagateway):
* `zabbix_version`: You can specifiy which zabbix release needs to be installed. Default is '2.2'. 
* `manage_firewall`: Wheter you want to manage the firewall. If true (Which is default), iptables will be configured to allow communications to zabbix ports.
* `manage_repo`:  If zabbix needs to be installed from the zabbix repositories (Default is true). When you have your own repositories, you'll set this to false. But you'll have to make sure that your repositorie is installed on the host.

The following is only availabe for the following classes: zabbix::server, zabbix::proxy & zabbix::agent
* `manage_resources`: As of release 0.4.0, when this parameter is set to true (Default is false) it make use of exported resources. You'll have an puppetdb configured before you can use this option. Information from the zabbix::agent, zabbix::proxy and zabbix::userparameters are able to export resources, which will be loaded on the zabbix::server.


###Reference zabbix-server
* `zabbix_url`: This is the url on which Zabbix should be available. Please make sure that the entry exists in the DNS configuration.
* `dbtype`: Which database is used for zabbix. Default is postgresql.
* `manage_database`: When the parameter 'manage_database' is set to true (Which is default), it will create the database and loads the sql files. Default the postgresql will be used as backend, mentioned in the params.pp file. You'll have to include the postgresql (or mysql) module yourself, as this module will require it.
* `zabbix_timezone`: On which timezone the machine is placed. This information is needed for the apache virtual host.
* `manage_vhost`: Will create an apache virtual host. Default is true.
* `apache_use_ssl`: Will create an ssl vhost. Also nonssl vhost will be created for redirect nonssl to ssl vhost.
* `apache_ssl_cert`: The location of the ssl certificate file. You'll need to make sure this file is present on the system, this module will not install this file.
* `apache_ssl_key`: The location of the ssl key file. You'll need to make sure this file is present on the system, this module will not install this file.
* `apache_ssl_cipher`: The ssl cipher used. Cipher is used from: https://wiki.mozilla.org/Security/Server_Side_TLS. 
* `apache_ssl_chain`: The ssl_chain file. You'll need to make sure this file is present on the system, this module will not install this file.
* `zabbix_api_user`: Username of user in Zabbix which is able to create hosts and edit hosts via the zabbix-api. Default: Admin
* `zabbix_api_pass`: Password for the user in Zabbix for zabbix-api usage. Default: zabbix

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-agent
* `server`: This is the ipaddress of the zabbix-server or zabbix-proxy.

The following parameters is only needed when `manage_resources` is set to true:
* `monitored_by_proxy`: When an agent is monitored via an proxy, enter the name of the proxy. The name is found in the webinterface via: Administration -> DM. If it isn't monitored by an proxy or `manage_resources` is false, this parameter can be empty.
* `agent_use_ip`: Default is set to true. Zabbix server (or proxy) will connect to this host via ip instead of fqdn. When set to false, it will connect via fqdn.
* `zbx_group`: Name of the hostgroup on which the agent will be installed. There can only be one hostgroup defined and should exists in the webinterface. Default: Linux servers
* `zbx_templates`: Name of the templates which will be assigned when agent is installed. Default (Array): 'Template OS Linux', 'Template App SSH Service'

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-proxy
* `zabbix_server_host`: The ipaddress or fqdn of the zabbix server.  
* `zabbix_server_port`: The port of the zabbix server. Default: 10051
* `manage_database`: When the parameter 'manage_database' is set to true (Which is default), it will create the database and loads the sql files. Default the postgresql will be used as backend, mentioned in the params.pp file. You'll have to include the postgresql (or mysql) module yourself, as this module will require it.

The following parameters is only needed when `manage_resources` is set to true:
* `use_ip`: Default is set to true. 
* `zbx_templates`: List of templates which are needed for the zabbix-proxy. Default: 'Template App Zabbix Proxy'
* `mode`: Which kind of proxy it is. 0 -> active, 1 -> passive

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-javagateway
There are some zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-userparameters

* `source`: File which holds several userparameter entries.
* `content`: When you have 1 userparameter entry which you want to install.
* `template`: When you use exported resources (when manage_resources on other components is set to true) you'll can add the name of the template which correspondents with the 'content' or 'source' which you add. The template will be added to the host.

##limitations
The module is only supported on the following operating systems:

Zabbix 2.4:

  * CentOS 6.x
  * RedHat 6.x
  * OracleLinux 6.x
  * Scientific Linux 6.x
  * Ubuntu 14.04
  * Debian 7

Zabbix 2.2:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Scientific Linux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 7
  * xenserver 6

Zabbix 2.0:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Scientific Linux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 6, 7
  * xenserver 6

This module is supported on both the community as the Enterprise version of Puppet. 

Zabbix 1.8 isn't supported (yet) with this module. 

Ubuntu 10.4 is officially supported by zabbix for Zabbix 2.0. I did have some issues with making it work, probably in a future release it is supported with this module as well.

Please be aware, that when manage_resources is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts. 

##Contributors
The following have contributed to this puppet module:
 * Suff
 * gattebury
 * sq4ind
 * nburtsev

Many thanks for this!

##Note
###Standard usage
*	Not specified as required but for working correctly, the epel repository should be available for the 'fping'|'fping6' packages.
*	Make sure you have sudo installed and configured with: !requiretty.
*   Make sure that selinux is permissive or disabled.


###When using exported resources
*	Please be aware, that when `manage_resources` is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts. 
*	First run of puppet on the zabbix-server can result in this error:

```ruby
Error: Could not run Puppet configuration client: cannot load such file -- zabbixapi
Error: Could not run: can't convert Puppet::Util::Log into Integer
```

See: http://comments.gmane.org/gmane.comp.sysutils.puppet.user/47508, comment:  Jeff McCune | 20 Nov 20:42 2012

```quote 
This specific issue is a chicken and egg problem where by a provider needs a gem, but the catalog run itself is the thing that provides the gem dependency. That is to say, even in Puppet 3.0 where we delay loading all of the providers until after pluginsync finishes, the catalog run hasn't yet installed the gem when the provider is loaded.

The reason I think this is basically a very specific incarnation of #6907 is because that ticket is pretty specific from a product functionality perspective, "You should not have to run puppet twice to use a provider."
```

After another puppet run, it will run succesfully.

* On a Red Hat family server, the 2nd run will sometimes go into error: 

```ruby
Could not evaluate: Connection refused - connect(2)
```

When running puppet again (for 3rd time) everything goes fine.
