require 'spec_helper'

describe 'zabbix::database' do
  let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}

  context 'zabbix::proxy - with manage_database is true' do
    #
    # Tests for zabbix::proxy, dbtype = postgresql and manage_database = true
    #
    context 'with dbtype = postgresql' do
      let(:params) { {:manage_database => true, :dbtype => 'postgresql', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :zabbix_type => 'proxy', :zabbix_version => '2.2'} }
      it do 
        should contain_class('zabbix::database::postgresql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'proxy',
          'db_name'        => 'zabbix-proxy',
          'db_user'        => 'zabbix-proxy',
          'db_pass'        => 'zabbix-proxy'
        })
      end
    end # END context "with dbtype = postgresql"

    #
    # Tests for zabbix::proxy, dbtype = mysql and manage_database = true
    #
    context 'with dbtype = mysql' do
      let(:params) { {:manage_database => true, :dbtype => 'mysql', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost', :zabbix_type => 'proxy', :zabbix_version => '2.2'} }
      it do 
        should contain_class('zabbix::database::mysql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'proxy',
          'db_name'        => 'zabbix-proxy',
          'db_user'        => 'zabbix-proxy',
          'db_pass'        => 'zabbix-proxy',
          'db_host'        => 'localhost'
        })
      end
    end # END context 'with dbtype = mysql'
  end

  #
  # Tests for zabbix::proxy, dbtype = postgresql and manage_database = false
  #
  context 'zabbix::proxy - with manage_database is false' do
    context 'with dbtype = postgresql' do
      let(:params) { {:manage_database => false, :dbtype => 'postgresql'} }
      it do 
        should_not contain_class('zabbix::database::postgresql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'proxy',
          'db_name'        => 'zabbix-proxy',
          'db_user'        => 'zabbix-proxy',
          'db_pass'        => 'zabbix-proxy'
        })
      end
    end # END context "with dbtype = postgresql"

    #
    # Tests for zabbix::proxy, dbtype = mysql and manage_database = false
    #
    context 'with dbtype = mysql' do
      let(:params) { {:manage_database => false, :dbtype => 'mysql'} }
      it do 
        should_not contain_class('zabbix::database::mysql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'proxy',
          'db_name'        => 'zabbix-proxy',
          'db_user'        => 'zabbix-proxy',
          'db_pass'        => 'zabbix-proxy',
          'db_host'        => 'localhost'
        })
      end
    end # END context 'with dbtype = mysql'
  end
  
  #
  # Tests for zabbix::server, dbtype = postgresql and manage_database = true
  #
  context 'zabbix::server - with manage_database is true' do
    context 'with dbtype = postgresql' do
      let(:params) { {:manage_database => true, :dbtype => 'postgresql', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :zabbix_type => 'server', :zabbix_version => '2.2'} }
      it do 
        should contain_class('zabbix::database::postgresql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'server',
          'db_name'        => 'zabbix-server',
          'db_user'        => 'zabbix-server',
          'db_pass'        => 'zabbix-server',
        })
      end
    end # END context "with dbtype = postgresql"

    #
    # Tests for zabbix::server, dbtype = mysql and manage_database = true
    #
    context 'with dbtype = mysql' do
      let(:params) { {:manage_database => true, :dbtype => 'mysql', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost', :zabbix_type => 'server', :zabbix_version => '2.2'} }
      it do 
        should contain_class('zabbix::database::mysql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'server',
          'db_name'        => 'zabbix-server',
          'db_user'        => 'zabbix-server',
          'db_pass'        => 'zabbix-server',
          'db_host'        => 'localhost'
        })
      end
    end # END context 'with dbtype = mysql'
  end

  #
  # Tests for zabbix::server, dbtype = postgresql and manage_database = false
  #  
  context 'zabbix::server - with manage_database is true' do
    context 'with dbtype = postgresql' do
      let(:params) { {:manage_database => false, :dbtype => 'postgresql'} }
      it do 
        should_not contain_class('zabbix::database::postgresql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'server',
          'db_name'        => 'zabbix-server',
          'db_user'        => 'zabbix-server',
          'db_pass'        => 'zabbix-server',
        })
      end
    end # END context "with dbtype = postgresql"

    #
    # Tests for zabbix::server, dbtype = mysql and manage_database = false
    #
    context 'with dbtype = mysql' do
      let(:params) { {:manage_database => false, :dbtype => 'mysql'} }
      it do 
        should_not contain_class('zabbix::database::mysql').with({
          'zabbix_version' => '2.2',
          'zabbix_type'    => 'server',
          'db_name'        => 'zabbix-server',
          'db_user'        => 'zabbix-servery',
          'db_pass'        => 'zabbix-server',
          'db_host'        => 'localhost'
        })
      end
    end # END context 'with dbtype = mysql'
  end
end

describe 'zabbix::database::mysql' do
  #
  # Tests for RHEL  6, zabbix_version 2.0
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 6.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 6.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for RHEL  6, zabbix_version 2.0
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 6.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 6.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  
  #
  # Tests for RHEL  5, zabbix_version 2.0
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 5.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 5.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.0*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.0*/create/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for RHEL  5, zabbix_version 2.2
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 5.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 6.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/doc/zabbix-*-mysql-2.2*/create && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/doc/zabbix-*-mysql-2.2*/create/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for DEBIAN  6, zabbix_version 2.0
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 6, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '6.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 6, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '6.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # context 'On a Debian OS' do

  #
  # Tests for DEBIAN  7, zabbix_version 2.0
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 7, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 7, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # context 'On a Debian OS' do

  #
  # Tests for DEBIAN  7, zabbix_version 2.2
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 7, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-proxy -pzabbix-proxy -D zabbix-proxy < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-proxy-mysql]',
          'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 7, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server', :db_host => 'localhost'} }
    
      it do should contain_exec('zabbix_server_create.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < schema.sql && touch schema.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/schema.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < images.sql && touch images.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/images.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
          'command'  => 'cd /usr/share/zabbix-*-mysql && mysql -u zabbix-server -pzabbix-server -D zabbix-server < data.sql && touch data.done',
          'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          'unless'   => 'test -f /usr/share/zabbix-*-mysql/data.done',
          'provider' => 'shell',
          'require'  => 'Package[zabbix-server-mysql]',
          'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a Debian OS' do
end # END describe 'zabbix::database::mysql'


describe 'zabbix::database::postgresql' do
  #
  # Tests for RHEL  6, zabbix_version 2.0
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 6.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
            
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 6.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for RHEL  6, zabbix_version 2.2
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 6.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 6.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  
  #
  # Tests for RHEL  5, zabbix_version 2.0
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 5.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 5.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.0*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.0*/create/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for RHEL  5, zabbix_version 2.2
  #   
  context 'On a RedHat OS' do
    #
    # Tests for RHEL 5.5, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for RHEL 5.5, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'redhat', :operatingsystem => 'RedHat', :operatingsystemrelease => '5.5'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/pgsql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/pgsql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/pgsql/.pgpass',
        'require'  => 'File[/var/lib/pgsql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/doc/zabbix-*-pgsql-2.2*/create && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/doc/zabbix-*-pgsql-2.2*/create/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a RedHat OS' do

  #
  # Tests for DEBIAN  6, zabbix_version 2.0
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 6, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '6.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 6, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '6.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # context 'On a Debian OS' do

  #
  # Tests for DEBIAN  7, zabbix_version 2.0
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 7, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.0', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 7, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.0', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
        
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # context 'On a Debian OS' do

  #
  # Tests for DEBIAN  7, zabbix_version 2.2
  #   
  context 'On a Debian OS' do
    #
    # Tests for Debian 7, zabbix-proxy
    #  
    context 'with zabbix_type is proxy' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'proxy', :zabbix_version => '2.2', :db_name => 'zabbix-proxy', :db_user => 'zabbix-proxy', :db_pass => 'zabbix-proxy'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-proxy]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
    
      it do should contain_exec('zabbix_proxy_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-proxy -d zabbix-proxy -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-proxy-pgsql]'],
        'notify'   => 'Service[zabbix-proxy]'
      ) end
    end # END context 'with zabbix_type is proxy'
    #
    # Tests for Debian 7, zabbix-server
    # 
    context 'with zabbix_type is server' do
      let(:facts) {{:osfamily => 'debian', :operatingsystem => 'debian', :operatingsystemrelease => '7.0'}}
      let(:params) { {:zabbix_type => 'server', :zabbix_version => '2.2', :db_name => 'zabbix-server', :db_user => 'zabbix-server', :db_pass => 'zabbix-server'} }

      it do should contain_file('/var/lib/postgresql/.pgpass').with(
        'ensure'  => 'present',
        'mode'    => '0600',
        'owner'   => 'postgres',
        'group'   => 'postgres',
        'require' => 'Postgresql::Server::Db[zabbix-server]'
        )
      end 

      it do should contain_exec('update_pgpass').with(
        'command' => 'echo localhost:5432:zabbix-server:zabbix-server:zabbix-server >> /var/lib/postgresql/.pgpass',
        'path'    => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'  => 'grep "localhost:5432:zabbix-server:zabbix-server:zabbix-server" /var/lib/postgresql/.pgpass',
        'require'  => 'File[/var/lib/postgresql/.pgpass]'
      ) end
        
      it do should contain_exec('zabbix_server_create.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f schema.sql && touch schema.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/schema.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_images.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f images.sql && touch images.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/images.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end
      it do should contain_exec('zabbix_server_data.sql').with(
        'command'  => 'cd /usr/share/zabbix-*-pgsql && sudo -u postgres psql -h localhost -U zabbix-server -d zabbix-server -f data.sql && touch data.done',
        'path'     => '/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'unless'   => 'test -f /usr/share/zabbix-*-pgsql/data.done',
        'provider' => 'shell',
        'require'  => ['Exec[update_pgpass]','Package[zabbix-server-pgsql]'],
        'notify'   => 'Service[zabbix-server]'
      ) end    
    end # END context 'with zabbix_type is server'
  end # END context 'On a Debian OS' do
end # END describe 'zabbix::database::mysql'