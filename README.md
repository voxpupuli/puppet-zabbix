# puppet-zabbix

[![Build Status](https://github.com/voxpupuli/puppet-zabbix/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-zabbix/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-zabbix/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-zabbix/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/zabbix.svg)](https://forge.puppetlabs.com/puppet/zabbix)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/zabbix.svg)](https://forge.puppetlabs.com/puppet/zabbix)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/zabbix.svg)](https://forge.puppetlabs.com/puppet/zabbix)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/zabbix.svg)](https://forge.puppetlabs.com/puppet/zabbix)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-zabbix)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-zabbix.svg)](LICENSE)
[![Donated by Werner Dijkerman](https://img.shields.io/badge/donated%20by-Werner%20Dijkerman-fb7047.svg)](#transfer-notice)

#### Table of Contents

1. [Overview](#overview)
2. [Upgrade](#upgrade)
    * [to 1.0.0](#100)
    * [to 2.0.0](#200)
3. [Module Description - What the module does and why it is useful](#module-description)
4. [Setup - The basics of getting started with the zabbix module](#setup)
    * [zabbix-server](#setup-zabbix-server)
5. [Usage - Configuration options and additional functionality](#usage)
    * [zabbix-server](#usage-zabbix-server)
    * [zabbix-agent](#usage-zabbix-agent)
    * [zabbix-proxy](#usage-zabbix-proxy)
    * [zabbix-javagateway](#usage-zabbix-javagateway)
    * [zabbix-sender](#usage-zabbix-sender)
    * [zabbix-userparameters](#usage-zabbix-userparameters)
    * [zabbix-template](#usage-zabbix-template)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Contributors](#contributors)
9. [Notes](#note)
    * [Some overall notes](#standard-usage)
    * [When using exported resources | manage_resources is true](#when-using-exported-resources)

## Overview

This module contains the classes for installing and configuring the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy
  - zabbix-javagateway
  - zabbix-sender

This readme will contain all basic information to get you started. Some more information can be found on the github wiki, location: https://github.com/voxpupuli/puppet-zabbix/wiki


## Module Description
When using this module, you can monitor your whole environment with zabbix. It can install the various zabbix components like the server and agent, but you will also be able to install specific "userparameter" file which zabbix can use for monitoring.

With the 0.4.0 release, you can - when you have configured exported resources - configure agents and proxies in the webinterface. So when you add an zabbix::agent to an host, it first install the agent onto the host. It will send some data to the puppetdb and when puppet runs on the zabbix-server it will create this new host via the zabbix-api.

Be aware when you have a lot of hosts, it will increase the puppet runtime on the zabbix-server host. It will check via the zabbix-api if hosts exits and costs time.

This module make uses of this gem: https://github.com/express42/zabbixapi
With this gem it is possible to create/update hosts/proxy in ruby easy.

## Upgrade
### 1.0.0
With release 1.0.0 the zabbix::server class is split into 3 classes:

  - zabbix::web
  - zabbix::server
  - zabbix::database

Now you can use 3 machines for each purpose. This is something for the bigger environments to spread the load.

When upgrading from 0.x.x to 1.x.x, be aware of the following changes:

  - Choose the correct zabbix setup for your environment *:
    - Single node
    - Multi node
  - Path changes for the database ".done" file. Create the following files in /etc/zabbix/:
    - /etc/zabbix/.schema.done
    - /etc/zabbix/.images.done
    - /etc/zabbix/.data.done
  - Rename of the following parameters:
    - dbtype --> database_type
    - dbhost --> database_host
    - dbuser --> database_user
    - dbpass --> database_password
    - dbschema --> database_schema
    - dbname --> database_name
    - dbsocket --> database_socket
    - dbport --> database_port

\* check [this](#usage-zabbix-server) document/paragraph how to setup your environment. There were multiple changes to make this work (Like moving parameters to other (new) classes).

In case I missed something, please let me know and will update this document.

### 2.0.0
Altough this is an major update, there is only one small change that we need to discuss and is specifically for the Zabbix Proxy.

The following properties for the zabbix::proxy needs to have the sizes:

  * vmwarecachesize
  * cachesize
  * historycachesize
  * historytextcachesize

Before 2.0.0 these could be used with an single integer, as in the template was hardcoded the 'M'. With release 2.0.0 you'll have to use the correct full size like: 8M, 16M or 2G.

## Setup
As this puppet module contains specific components for zabbix, you'll need to specify which you want to install. Every zabbix component has his own zabbix:: class. Here you'll find each component.

### Setup zabbix-server
This will install an basic zabbix-server instance. You'll have to decide if you want to run everything on a single host or multiple hosts. When installing on a single host, the 'zabbix' class can be used. When you want to use more than 1 host, you'll need the following classes:
  - zabbix::web
  - zabbix::server
  - zabbix::database

You can see at "usage" in this documentation how all of this can be achieved.

You will need to supply one parameter: zabbix_url. This is the url on which the zabbix instance will be available. With the example at "setup", the zabbix webinterface will be: http://zabbix.example.com.

When installed succesfully, zabbix web interface will be accessable and you can login with the default credentials:

Username: Admin
Password: zabbix

## Usage
The following will provide an basic usage of the zabbix components.

### Usage zabbix-server

The zabbix-server can be used in 2 ways:
* one node setup
* multiple node setup.

The following is an example for using the PostgreSQL as database:

```ruby
node 'zabbix.example.com' {
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  class { 'postgresql::server': }

  class { 'zabbix':
    zabbix_url    => 'zabbix.example.com',
  }
}
```

When you want to make use of an MySQL database as backend:
```ruby
node 'zabbix.example.com' {
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => 'zabbix.example.com',
    database_type => 'mysql',
  }
}
```

Everything will be installed on the same server. There is also an possibility to seperate the components, please check the following wiki:
https://github.com/voxpupuli/puppet-zabbix/wiki/Multi-node-Zabbix-Server-setup

Please note that if you use apache as the frontend (which is the default) and SELinux is enabled, you need to set these SEBooleans (preferably in a profile) to allow apache to connect to the database:
```puppet
if $facts['selinux'] {
  selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
    persistent => true,
    value      => 'on',
  }
}
```

### Usage zabbix-agent

Basic one way of setup, wheter it is monitored by zabbix-server or zabbix-proxy:
```ruby
class { 'zabbix::agent':
  server => '192.168.20.11',
}
```

To install on Windows without requiring the use of `chocolatey`:
```ruby
$tmpdir = $facts['windows_env']['TMP'];

download_file { 'get zabbix-installer.msi':
  url                   => "https://<hostname>/zabbix_agent-${zabbix_version}-windows-amd64-openssl.msi",
  destination_directory => $tmpdir,
  destination_file      => "zabbix_agent-windows-amd64-openssl.msi",
}

class { 'zabbix::agent':
  zabbix_version          => $zabbix_version,
  manage_resources        => true,
  manage_choco            => false,
  zabbix_package_agent    => "Zabbix Agent (64-bit)",
  zabbix_package_state    => present,
  zabbix_package_provider => 'windows',
  zabbix_package_source   => "${tmpdir}/zabbix_agent-windows-amd64-openssl.msi",
}
```

### Usage zabbix-proxy

Like the zabbix-server, the zabbix-proxy can also be used in 2 ways:
* single node
* multiple node

The following is an example for using the PostgreSQL as database:
```ruby
node 'proxy.example.com' {
  class { 'postgresql::server': }

  class { 'zabbix::database':
    database_type => 'postgresql',
  }

  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    database_type      => 'postgresql',
  }
}
```

When you want to make use of an MySQL database as backend:
```ruby
node 'proxy.example.com' {
  class { 'mysql::server': }

  class { 'zabbix::database':
    database_type => 'mysql',
  }

  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    database_type      => 'mysql',
  }
}
```

When you want to make use of an sqlite database as backend:

```ruby
class { 'zabbix::proxy':
  zabbix_server_host => 'zabbix.example.com',
  database_type      => 'sqlite',
  database_name      => '/tmp/database',
}
```

You'll have to specify the location to the file in the `database_name` parameter. Zabbix should have write access to the file/directory.

Everything will be installed on the same server. There is also an possibility to seperate the components, please check the following wiki:
https://github.com/voxpupuli/puppet-zabbix/wiki/Multi-node-Zabbix-Proxy-setup

### Usage zabbix-javagateway

The zabbix-javagateway can be used with an zabbix-server or zabbix-proxy. You'll need to install it on an server. (Can be together with zabbix-server or zabbix-proxy, you can even install it on a sperate machine.). The following example shows you to use it on a seperate machine.

```ruby
node 'server05.example.com' {
# My ip: 192.168.20.15
  class { 'zabbix::javagateway': }
}
```

When installed on seperate machine, the zabbix::server configuration should be updated by adding the `javagateway` parameter.

```ruby
node 'server01.example.com' {
  class { 'zabbix::server':
    zabbix_url  => 'zabbix.example.com',
    javagateway => '192.168.20.15',
  }
}
```

Or when using with an zabbix-proxy:

```ruby
node 'server11.example.com' {
  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    javagateway        => '192.168.20.15',
  }
}
```
### Usage zabbix-sender

The zabbix-sender installation is quite simple and straightforward:
```ruby
include zabbix::sender
```
### Usage zabbix-userparameters
Using an 'source' file:

```ruby
zabbix::userparameters { 'mysql':
  source => 'puppet:///modules/zabbix/mysqld.conf',
}
```

Or for example when you have just one entry:

```ruby
zabbix::userparameters { 'mysql':
  content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive',
}
```

Using an [LLD](https://www.zabbix.com/documentation/2.4/manual/discovery/low_level_discovery) 'script' file:

```ruby
zabbix::userparameters { 'lld_snort.sh':
  script => 'puppet:///modules/zabbix/lld_snort.sh',
}
```

When you are using Hiera or The Foreman, you can use it like this:
```yaml
---
classes:
  zabbix::userparameter:
    data:
      mongo:
        source: puppet:///modules/zabbix/mongo.conf
```

Content of the mongo.conf:
```
UserParameter=mongo.coll.count[*],echo "db.setSlaveOk();db.getCollection('$1').count()" | /opt/mongo/bin/mongo processor | sed -n 3p
UserParameter=mongo.db.queries,echo "db.currentOp().inprog.length" | /opt/mongo/bin/mongo processor | sed -n 3p
```

Screenshot from The Foreman (With thanks to "inspired-geek" )
![image](https://cloud.githubusercontent.com/assets/1792014/10131286/d0477bd4-65d7-11e5-88cb-e7f81e421ef3.png)

When running the puppet-agent command, it will install the mongo.conf file on the host.

### Usage zabbix-template

With the 'zabbix::template' define, you can install Zabbix templates via the API. You'll have to make sure you store the XML file somewere on your puppet server or in your module.

Please be aware that you can only make use of this feature when you have configured the module to make use of exported resources.

You can install the MySQL template xml via the next example:
```ruby
zabbix::template { 'Template App MySQL':
  templ_source => 'puppet:///modules/zabbix/MySQL.xml'
}
```

`zabbix::template` class accepts `zabbix_version` parameter, by default is set to module's default Zabbix version.
Please override if you are using a different version.
```ruby
zabbix::template { 'Template App MySQL':
  templ_source   => 'puppet:///modules/zabbix/MySQL.xml',
  zabbix_version => '5.2'
}
```

## Zabbix Upgrades

It is possible to do upgrades via this module. An example for the zabbix agent:

```puppet
class{'zabbix::agent':
  zabbix_version => '2.4',
  manage_repo    => true,
}
```

This will install the latest zabbix 2.4 agent for you. The module won't to any upgrades nor install patch releases. If you want to get patch releases automatically:

```puppet
class{'zabbix::agent':
  zabbix_version       => '2.4',
  manage_repo          => true,
  zabbix_package_state => 'latest',
}
```

Let's asume zabbix just released version 3.4. Than you can do upgrades as follow:
```puppet
class{'zabbix::agent':
  zabbix_version       => '3.4',
  manage_repo          => true,
  zabbix_package_state => 'latest',
}
```

You can also tell the module to only create the new repository, but not to update the existing agent:

```puppet
class{'zabbix::agent':
  zabbix_version       => '3.4',
  manage_repo          => true,
  zabbix_package_state => 'installed',
}
```

Last but not least you can disable the repo management completely, which will than install zabbix from the present system repos:

```puppet
class{'zabbix::agent':
  manage_repo          => false,
  zabbix_package_state => 'present',
}
```

Even in this scenario you can do automatic upgrades via the module (it is the job of the user to somehow bring updates into the repo, for example by managing the repo on their own):

```puppet
class{'zabbix::agent':
  manage_repo          => false,
  zabbix_package_state => 'latest',
}
```
## Reference
Take a look at the [REFERENCE.md](https://github.com/voxpupuli/puppet-zabbix/blob/master/REFERENCE.md).

## Limitations

This module supports Zabbix 4.0, 5.0, 5.2, 5.4 and 6.0. The upstream supported versions are documented [here](https://www.zabbix.com/de/life_cycle_and_release_policy)
Please have a look into the metadata.json for all supported operating systems.

This module is supported on both the community and the Enterprise version of Puppet.

Please be aware, that when manage_resources is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts.

## Contributors

**ericsysmin** will be helping and maintaining this puppet module. In Github terms he is an Collaborator. So don't be suprised if he acceps/rejects Pull Requests and comment in issues.

The following have contributed to this puppet module:

 * Suff
 * gattebury
 * sq4ind
 * nburtsev
 * actionjack
 * karolisc
 * lucas42
 * f0
 * mmerfort
 * genebean
 * meganuke19
 * fredprod
 * ericsysmin
 * JvdW
 * rleemorlang
 * genebean
 * exptom
 * sbaryakov
 * roidelapluie
 * andresvia
 * ju5t
 * elricsfate
 * IceBear2k
 * altvnk
 * rnelson0
 * hkumarmk
 * Wprosdocimo
 * 1n
 * szemlyanoy
 * Wprosdocimo
 * sgnl05
 * hmn
 * BcTpe4HbIu
 * mschuett
 * claflico
 * bastelfreak
 * Oyabi
 * akostetskiy
 * DjxDeaf
 * tcatut
 * inspired-geek
 * ekohl
 * z3rogate
 * mkrakowitzer
 * eander210
 * hkumarmk
 * ITler
 * slashr00t
 * channone-arif-nbcuni
 * BcTpe4HbIu
 * vide

Many thanks for this!
(If I have forgotten you, please let me know and put you in the list of fame. :-))

## Note
### Standard usage
*	Not specified as required but for working correctly, the epel repository should be available for the 'fping'|'fping6' packages.
*	Make sure you have sudo installed and configured with: !requiretty.

### SE Linux

On systems with SE Linux active and enforcing, Zabbix agent will be limited unless given proper rights with an SE Linux module.
This Puppet module will apply some default SE Linux rules for it.
More can be provided if needed by using two class parameters, for example in Hiera YAML:

```yaml
zabbix::agent::selinux_require:
  - 'type zabbix_agent_t'
  - 'class process setrlimit'
zabbix::agent::selinux_rules:
  zabbix_agent_t:
    - 'allow zabbix_agent_t self:process setrlimit'
  zabbix_script_t:
    - 'allow zabbix_script_t zabbix_agent_t:process sigchld'
```

### When using exported resources

At the moment of writing, the puppet run will fail one or more times when `manage_resources` is set to true when you install an fresh Zabbix server. It is an issue and I'm aware of it. Don't know yet how to solve this, but someone suggested to try puppet stages and for know I haven't made it work yet.

*	Please be aware, that when `manage_resources` is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts. You also need to ensure that you've got ruby installed on your machine, and related packages to compile native extensions for gems (usually gcc and make).
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

## Transfer Notice

This plugin was originally authored by [Werner Dijkerman](https://werner-dijkerman.nl/).
The maintainer preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute at https://github.com/voxpupuli/puppet-zabbix

Previously: https://github.com/dj-wasabi/puppet-zabbix
