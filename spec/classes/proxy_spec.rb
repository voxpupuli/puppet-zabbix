require 'spec_helper'

describe 'zabbix::proxy' do
  # Set some facts / params.
  let(:params) { {:zabbix_server_host => '192.168.1.1'} }

  # Running an Debian OS.
  context 'On a Debian OS' do
    # Set some facts first.
    let(:facts) {{:operatingsystem => 'Debian', :operatingsystemrelease => '7', :osfamily => 'Debian', :lsbdistid => 'Debian',:fqdn => 'rspec.puppet.com'}}
    context "when declaring manage_repo is true" do
      let :params do
        { :manage_repo => true }
      end

      # Testing with the postgresql as database type.
      describe 'with dbtype as postgresql' do
        let :params do { :dbtype => 'postgresql' } end
        # Make sure we have the zabbix::repo 
        it do 
          should contain_class('zabbix::repo').with({
            'zabbix_version' => '2.2',
          })
        end

        # Make sure we have 'required' the zabbix::repo module for the package.
        it do 
          should contain_package('zabbix-proxy-pgsql').with_require('Class[Zabbix::Repo]')
        end

        # Make sure package will be installed.
        context 'when postgresql is dbtype' do
          let :params do { :dbtype => 'postgresql' } end
          it do
            should contain_package('zabbix-proxy-pgsql').with({
            :ensure => :present,
            :name   => 'zabbix-proxy-pgsql',
          })
          end
        end # END context 'when postgresql is dbtype'        

        # We need an zabbix-agent service.
        context 'and manage service' do
          let :params do { :dbtype => 'postgresql' } end
          it { should contain_service('zabbix-proxy').with(
            'ensure'     => 'running',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
            'require'    => ['Package[zabbix-proxy-pgsql]','File[/etc/zabbix/zabbix_proxy.conf.d/]','File[/etc/zabbix/zabbix_proxy.conf]']
            )
          }
        end # END context 'and manage service'

        context 'and configure file' do
          let :params do { :dbtype => 'postgresql' } end
          # Make sure the confifuration file is present.
          it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with(
#            'ensure'  => 'present',
#            'owner'   => 'zabbix',
#            'group'   => 'zabbix',
#            'mode'    => '0644',
            'notify'  => 'Service[zabbix-proxy]',
            'require' => 'Package[zabbix-proxy-pgsql]',
            'replace' => 'true'
            )
          }        
          end     
        end # END context 'and configure file'

      # Testing with the mysql as database type.
      describe 'with repo mysql' do
        let :params do { :dbtype => 'mysql' } end
        # Make sure we have the zabbix::repo 
        it do 
          should contain_class('zabbix::repo').with({
            'zabbix_version' => '2.2',
          })
        end

        # Make sure we have 'required' the zabbix::repo module for the package.
        it do 
          should contain_package('zabbix-proxy-mysql').with_require('Class[Zabbix::Repo]')
        end
      end
    end # END describe 'with repo mysql'

    context 'when declaring manage_repo is false' do
      let :params do
        { :manage_repo => false }
      end
      describe 'without repo' do
          it { should_not contain_class('Zabbix::Repo') }
      end
    end # END context 'when declaring manage_repo is false'

    # Make sure package will be installed.
    context 'when mysql is dbtype' do
      let :params do { :dbtype => 'mysql' } end
      it do
        should contain_package('zabbix-proxy-mysql').with({
        :ensure => :present,
        :name   => 'zabbix-proxy-mysql',
      })
      end
    end # END context 'when mysql is dbtype'
  
 
      # Include directory should be available.
    it { should contain_file('/etc/zabbix/zabbix_proxy.conf.d/').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/zabbix/zabbix_proxy.conf]'
      )
    }    

    describe 'with zabbix::database class' do
      let :params do { :dbtype => 'postgresql' } end
      # Make sure we have the zabbix::database
      it do 
        should contain_class('zabbix::database').with({
          'manage_database' => 'true',
          'dbtype'          => 'postgresql',
          'zabbix_type'     => 'proxy',
          'zabbix_version'  => '2.2',
          'db_name'         => 'zabbix-proxy',
          'db_user'         => 'zabbix-proxy',
          'db_pass'         => 'zabbix-proxy',
          'db_host'         => 'localhost',
          'before'          => 'Service[zabbix-proxy]',
       })
      end
    end

    describe 'with zabbix::database class' do
      let :params do { :dbtype => 'mysql' } end
      # Make sure we have the zabbix::database
      it do 
        should contain_class('zabbix::database').with({
          'manage_database' => 'true',
          'dbtype'          => 'mysql',
          'zabbix_type'     => 'proxy',
          'zabbix_version'  => '2.2',
          'db_name'         => 'zabbix-proxy',
          'db_user'         => 'zabbix-proxy',
          'db_pass'         => 'zabbix-proxy',
          'db_host'         => 'localhost',
          'before'          => 'Service[zabbix-proxy]',
       })
      end
    end  

    # So if manage_firewall is set to true, it should install
    # the firewall rule.
    context "when declaring manage_firewall is true" do
      let :params do
        { :manage_firewall => true }
      end
      describe 'with firewall' do
        it { should contain_firewall('151 zabbix-proxy') }
      end
    end
  
    # If not, we don't want an firewall rule.
    context "when declaring manage_firewall is false" do
      let :params do
        { :manage_firewall => false }
      end
      describe 'without firewall' do
        it { should_not contain_firewall('151 zabbix-proxy') }
      end
    end 
  end # END context 'On a Debian OS'

  context 'On a Ubuntu OS' do
    # Set some facts first.
    let(:facts) {{:operatingsystem => 'Ubuntu', :operatingsystemrelease => '12.04', :osfamily => 'Ubuntu', :lsbdistid => 'Ubuntu',:fqdn => 'rspec.puppet.com'}}
    context "when declaring manage_repo is true" do
      let :params do
        { :manage_repo => true }
      end

      # Testing with the postgresql as database type.
      describe 'with dbtype as postgresql' do
        let :params do { :dbtype => 'postgresql' } end
        # Make sure we have the zabbix::repo 
        it do 
          should contain_class('zabbix::repo').with({
            'zabbix_version' => '2.2',
          })
        end

        # Make sure we have 'required' the zabbix::repo module for the package.
        it do 
          should contain_package('zabbix-proxy-pgsql').with_require('Class[Zabbix::Repo]')
        end

        # Make sure package will be installed.
        context 'when postgresql is dbtype' do
          let :params do { :dbtype => 'postgresql' } end
          it do
            should contain_package('zabbix-proxy-pgsql').with({
            :ensure => :present,
            :name   => 'zabbix-proxy-pgsql',
          })
          end
        end # END context 'when postgresql is dbtype'        

        # We need an zabbix-agent service.
        context 'and manage service' do
          let :params do { :dbtype => 'postgresql' } end
          it { should contain_service('zabbix-proxy').with(
            'ensure'     => 'running',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
            'require'    => ['Package[zabbix-proxy-pgsql]','File[/etc/zabbix/zabbix_proxy.conf.d/]','File[/etc/zabbix/zabbix_proxy.conf]']
            )
          }
        end # END context 'and manage service'

        context 'and configure file' do
          let :params do { :dbtype => 'postgresql' } end
          # Make sure the confifuration file is present.
          it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with(
#            'ensure'  => 'present',
#            'owner'   => 'zabbix',
#            'group'   => 'zabbix',
#            'mode'    => '0644',
            'notify'  => 'Service[zabbix-proxy]',
            'require' => 'Package[zabbix-proxy-pgsql]',
            'replace' => 'true'
            )
          }        
          end     
        end # END context 'and configure file'

##        
##  Disabled due to puppetlabs-mysql doesn't support ubuntu
##
      # Testing with the mysql as database type.
#      describe 'with repo mysql' do
#        let :params do { :dbtype => 'mysql' } end
#        # Make sure we have the zabbix::repo 
#        it do 
#          should contain_class('zabbix::repo').with({
#            'zabbix_version' => '2.2',
#          })
#        end
#
#        # Make sure we have 'required' the zabbix::repo module for the package.
#        it do 
#          should contain_package('zabbix-proxy-mysql').with_require('Class[Zabbix::Repo]')
#        end
#      end
    end # END describe 'with repo mysql'

#    context 'when declaring manage_repo is false' do
#      let :params do
#        { :manage_repo => false }
#      end
#      describe 'without repo' do
#          it { should_not contain_class('Zabbix::Repo') }
#      end
#    end # END context 'when declaring manage_repo is false'
#
#    # Make sure package will be installed.
#    context 'when mysql is dbtype' do
#      let :params do { :dbtype => 'mysql' } end
#      it do
#        should contain_package('zabbix-proxy-mysql').with({
#        :ensure => :present,
#        :name   => 'zabbix-proxy-mysql',
#      })
#      end
#    end # END context 'when mysql is dbtype'
  
 
      # Include directory should be available.
    it { should contain_file('/etc/zabbix/zabbix_proxy.conf.d/').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/zabbix/zabbix_proxy.conf]'
      )
    }    

    describe 'with zabbix::database class' do
      let :params do { :dbtype => 'postgresql' } end
      # Make sure we have the zabbix::database
      it do 
        should contain_class('zabbix::database').with({
          'manage_database' => 'true',
          'dbtype'          => 'postgresql',
          'zabbix_type'     => 'proxy',
          'zabbix_version'  => '2.2',
          'db_name'         => 'zabbix-proxy',
          'db_user'         => 'zabbix-proxy',
          'db_pass'         => 'zabbix-proxy',
          'db_host'         => 'localhost',
          'before'          => 'Service[zabbix-proxy]',
       })
      end
    end

##        
##  Disabled due to puppetlabs-mysql doesn't support ubuntu
##

#    describe 'with zabbix::database class' do
#      let :params do { :dbtype => 'mysql' } end
#      # Make sure we have the zabbix::database
#      it do 
#        should contain_class('zabbix::database').with({
#          'manage_database' => 'true',
#          'dbtype'          => 'mysql',
#          'zabbix_type'     => 'proxy',
#          'zabbix_version'  => '2.2',
#          'db_name'         => 'zabbix-proxy',
#          'db_user'         => 'zabbix-proxy',
#          'db_pass'         => 'zabbix-proxy',
#          'db_host'         => 'localhost',
#          'before'          => 'Service[zabbix-proxy]',
#       })
#      end
#    end  

    # So if manage_firewall is set to true, it should install
    # the firewall rule.
    context "when declaring manage_firewall is true" do
      let :params do
        { :manage_firewall => true }
      end
      describe 'with firewall' do
        it { should contain_firewall('151 zabbix-proxy') }
      end
    end
  
    # If not, we don't want an firewall rule.
    context "when declaring manage_firewall is false" do
      let :params do
        { :manage_firewall => false }
      end
      describe 'without firewall' do
        it { should_not contain_firewall('151 zabbix-proxy') }
      end
    end 
  end # END context 'On a Ubuntu OS'


  # Running an RedHat OS.
  context 'On a RedHat OS' do
    # Set some facts first.
    let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5', :osfamily => 'RedHat',:fqdn => 'rspec.puppet.com'}}
    context "when declaring manage_repo is true" do
      let :params do
        { :manage_repo => true }
      end

      # Testing with the postgresql as database type.
      describe 'with dbtype as postgresql' do
        let :params do { :dbtype => 'postgresql' } end
        # Make sure we have the zabbix::repo 
        it do 
          should contain_class('zabbix::repo').with({
            'zabbix_version' => '2.2',
          })
        end

        # Make sure we have 'required' the zabbix::repo module for the package.
        it do 
          should contain_package('zabbix-proxy-pgsql').with_require('Class[Zabbix::Repo]')
        end

        # Make sure package will be installed.
        context 'when postgresql is dbtype' do
          let :params do { :dbtype => 'postgresql' } end
          it do
            should contain_package('zabbix-proxy-pgsql').with({
            :ensure => :present,
            :name   => 'zabbix-proxy-pgsql',
          })
          end
        end # END context 'when postgresql is dbtype'        

        # We need an zabbix-agent service.
        context 'and manage service' do
          let :params do { :dbtype => 'postgresql' } end
          it { should contain_service('zabbix-proxy').with(
            'ensure'     => 'running',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
            'require'    => ['Package[zabbix-proxy-pgsql]','File[/etc/zabbix/zabbix_proxy.conf.d/]','File[/etc/zabbix/zabbix_proxy.conf]']
            )
          }
        end # END context 'and manage service'

        context 'and configure file' do
          let :params do { :dbtype => 'postgresql' } end
          # Make sure the confifuration file is present.
          it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with(
#            'ensure'  => 'present',
#            'owner'   => 'zabbix',
#            'group'   => 'zabbix',
#            'mode'    => '0644',
            'notify'  => 'Service[zabbix-proxy]',
            'require' => 'Package[zabbix-proxy-pgsql]',
            'replace' => 'true'
            )
          }        
          end     
        end # END context 'and configure file'

      # Testing with the mysql as database type.
      describe 'with repo mysql' do
        let :params do { :dbtype => 'mysql' } end
        # Make sure we have the zabbix::repo 
        it do 
          should contain_class('zabbix::repo').with({
            'zabbix_version' => '2.2',
          })
        end

        # Make sure we have 'required' the zabbix::repo module for the package.
        it do 
          should contain_package('zabbix-proxy-mysql').with_require('Class[Zabbix::Repo]')
        end
      end
    end # END describe 'with repo mysql'

    context 'when declaring manage_repo is false' do
      let :params do
        { :manage_repo => false }
      end
      describe 'without repo' do
          it { should_not contain_class('Zabbix::Repo') }
      end
    end # END context 'when declaring manage_repo is false'

    # Make sure package will be installed.
    context 'when mysql is dbtype' do
      let :params do { :dbtype => 'mysql' } end
      it do
        should contain_package('zabbix-proxy-mysql').with({
        :ensure => :present,
        :name   => 'zabbix-proxy-mysql',
      })
      end
    end # END context 'when mysql is dbtype'

    context 'install the proxy' do
      it do
        should contain_package('zabbix-proxy').with({
        :ensure => :present,
        :name   => 'zabbix-proxy',
      })
      end
    end # END context 'install the proxy'

    # Include directory should be available.
    it { should contain_file('/etc/zabbix/zabbix_proxy.conf.d/').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/zabbix/zabbix_proxy.conf]'
      )
    }    

    describe 'with zabbix::database class' do
      let :params do { :dbtype => 'postgresql' } end
      # Make sure we have the zabbix::database
      it do 
        should contain_class('zabbix::database').with({
          'manage_database' => 'true',
          'dbtype'          => 'postgresql',
          'zabbix_type'     => 'proxy',
          'zabbix_version'  => '2.2',
          'db_name'         => 'zabbix-proxy',
          'db_user'         => 'zabbix-proxy',
          'db_pass'         => 'zabbix-proxy',
          'db_host'         => 'localhost',
          'before'          => 'Service[zabbix-proxy]',
       })
      end
    end

    describe 'with zabbix::database class' do
      let :params do { :dbtype => 'mysql' } end
      # Make sure we have the zabbix::database
      it do 
        should contain_class('zabbix::database').with({
          'manage_database' => 'true',
          'dbtype'          => 'mysql',
          'zabbix_type'     => 'proxy',
          'zabbix_version'  => '2.2',
          'db_name'         => 'zabbix-proxy',
          'db_user'         => 'zabbix-proxy',
          'db_pass'         => 'zabbix-proxy',
          'db_host'         => 'localhost',
          'before'          => 'Service[zabbix-proxy]',
       })
      end
    end  

    # So if manage_firewall is set to true, it should install
    # the firewall rule.
    context "when declaring manage_firewall is true" do
      let :params do
        { :manage_firewall => true }
      end
      describe 'with firewall' do
        it { should contain_firewall('151 zabbix-proxy') }
      end
    end
  
    # If not, we don't want an firewall rule.
    context "when declaring manage_firewall is false" do
      let :params do
        { :manage_firewall => false }
      end
      describe 'without firewall' do
        it { should_not contain_firewall('151 zabbix-proxy') }
      end
    end
  end # END context 'On a RedHat OS'

  
  # Make sure we have set some vars in zabbix_agentd.conf file. This is configuration file is the same on all
  # operating systems. So we aren't testing this for all opeating systems, just this one.
  context 'zabbix_proxy.conf configuration' do
    let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5', :osfamily => 'RedHat',:fqdn => 'rspec.puppet.com'}}

    context 'with mode => 0' do
      let(:params) { {:mode => '0'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyMode=0$}
      end
    end

    context 'with zabbix_server_host => 192.168.1.1' do
      let(:params) { {:zabbix_server_host => '192.168.1.1'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Server=192.168.1.1$}
      end
    end

    context 'with zabbix_server_port => 10051' do
      let(:params) { {:zabbix_server_port => '10051'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ServerPort=10051$}
      end
    end

    context 'with zabbix_server_port => 10051' do
      let(:params) { {:zabbix_server_port => '10051'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ServerPort=10051$}
      end
    end

    context 'with Hostname => rspec.puppet.com' do
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Hostname=rspec.puppet.com$}
      end
    end

    context 'with listenport => 10051' do
      let(:params) { {:listenport => '10051'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ListenPort=10051$}
      end
    end 

    context 'with logfile => /var/log/zabbix/proxy_server.log' do
      let(:params) { {:logfile => '/var/log/zabbix/proxy_server.log'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogFile=/var/log/zabbix/proxy_server.log$}
      end
    end 

    context 'with logfilesize => 15' do
      let(:params) { {:logfilesize => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogFileSize=15$}
      end
    end   

    context 'with debuglevel => 4' do
      let(:params) { {:debuglevel => '4'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DebugLevel=4$}
      end
    end   

    context 'with pidfile => /var/run/zabbix/proxy_server.pid' do
      let(:params) { {:pidfile => '/var/run/zabbix/proxy_server.pid'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^PidFile=/var/run/zabbix/proxy_server.pid$}
      end
    end   

    context 'with dbhost => localhost' do
      let(:params) { {:dbhost => 'localhost'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBHost=localhost$}
      end
    end   

    context 'with dbname => zabbix-proxy' do
      let(:params) { {:dbname => 'zabbix-proxy'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBName=zabbix-proxy$}
      end
    end   

    context 'with dbschema => zabbix-proxy' do
      let(:params) { {:dbschema => 'zabbix-proxy'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBSchema=zabbix-proxy$}
      end
    end   

    context 'with dbuser => zabbix-proxy' do
      let(:params) { {:dbuser => 'zabbix-proxy'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBUser=zabbix-proxy$}
      end
    end   

    context 'with dbpassword => zabbix-proxy' do
      let(:params) { {:dbpassword => 'zabbix-proxy'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBPassword=zabbix-proxy$}
      end
    end   

    context 'with localbuffer => 0' do
      let(:params) { {:localbuffer => '0'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyLocalBuffer=0$}
      end
    end   

    context 'with offlinebuffer => 1' do
      let(:params) { {:offlinebuffer => '1'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyOfflineBuffer=1$}
      end
    end   

    context 'with heartbeatfrequency => 60' do
      let(:params) { {:heartbeatfrequency => '60'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HeartbeatFrequency=60$}
      end
    end   

    context 'with configfrequency => 3600' do
      let(:params) { {:configfrequency => '3600'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ConfigFrequency=3600$}
      end
    end   

    context 'with datasenderfrequency => 1' do
      let(:params) { {:datasenderfrequency => '1'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DataSenderFrequency=1$}
      end
    end   

    context 'with startpollers => 15' do
      let(:params) { {:startpollers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPollers=15$}
      end
    end   

    context 'with startipmipollers => 15' do
      let(:params) { {:startipmipollers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartIPMIPollers=15$}
      end
    end   

    context 'with startpollersunreachable => 15' do
      let(:params) { {:startpollersunreachable => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPollersUnreachable=15$}
      end
    end   

    context 'with starttrappers => 15' do
      let(:params) { {:starttrappers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartTrappers=15$}
      end
    end   

    context 'with startpingers => 15' do
      let(:params) { {:startpingers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPingers=15$}
      end
    end   

    context 'with startdiscoverers => 15' do
      let(:params) { {:startdiscoverers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartDiscoverers=15$}
      end
    end   

    context 'with starthttppollers => 15' do
      let(:params) { {:starthttppollers => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartHTTPPollers=15$}
      end
    end   

    context 'with javagateway => 192.168.1.2' do
      let(:params) { {:javagateway => '192.168.1.2'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^JavaGateway=192.168.1.2$}
      end
    end   

    context 'with javagatewayport => 10051' do
      let(:params) { {:javagateway => '192.168.1.2', :javagatewayport => '10051'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^JavaGatewayPort=10051$}
      end
    end   

    context 'with startjavapollers => 5' do
      let(:params) { {:javagateway => '192.168.1.2', :startjavapollers => '5'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartJavaPollers=5$}
      end
    end   

    context 'with startvmwarecollector => 0' do
      let(:params) { {:startvmwarecollector => '0'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartVMwareCollectors=0$}
      end
    end   

    context 'with vmwarefrequency => 60' do
      let(:params) { {:vmwarefrequency => '60'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^VMwareFrequency=60$}
      end
    end   

    context 'with vmwarecachesize => 8' do
      let(:params) { {:vmwarecachesize => '8'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^VMwareCacheSize=8M$}
      end
    end 
    
    context 'with snmptrapperfile => 60' do
      let(:params) { {:snmptrapperfile => '/tmp/zabbix_traps.tmp'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^SNMPTrapperFile=/tmp/zabbix_traps.tmp$}
      end
    end 
    
    context 'with snmptrapper => 0' do
      let(:params) { {:snmptrapper => '0'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartSNMPTrapper=0$}
      end
    end 

    context 'with listenip => 192.168.1.1' do
      let(:params) { {:listenip => '192.168.1.1'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ListenIp=192.168.1.1$}
      end
    end 
        
    context 'with housekeepingfrequency => 1' do
      let(:params) { {:housekeepingfrequency => '1'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HousekeepingFrequency=1$}
      end
    end 
    
    context 'with casesize => 8' do
      let(:params) { {:casesize => '8'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^CacheSize=8M$}
      end
    end 
    
    context 'with startdbsyncers => 4' do
      let(:params) { {:startdbsyncers => '4'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartDBSyncers=4$}
      end
    end 

    context 'with historycachesize => 16' do
      let(:params) { {:historycachesize => '16'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HistoryCacheSize=16M$}
      end
    end   
  
    context 'with historytextcachesize => 8' do
      let(:params) { {:historytextcachesize => '8'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HistoryTextCacheSize=8M$}
      end
    end 
    
    context 'with timeout => 20' do
      let(:params) { {:timeout => '20'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Timeout=20$}
      end
    end 

    context 'with trappertimeout => 16' do
      let(:params) { {:trappertimeout => '16'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^TrapperTimeout=16$}
      end
    end   
  
    context 'with unreachableperiod => 45' do
      let(:params) { {:unreachableperiod => '45'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachablePeriod=45$}
      end
    end 

    context 'with unavaliabledelay => 60' do
      let(:params) { {:unavaliabledelay => '60'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnavailableDelay=60$}
      end
    end    
  
    context 'with unreachabedelay => 15' do
      let(:params) { {:unreachabedelay => '15'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachableDelay=15$}
      end
    end 

    context 'with externalscripts => 60' do
      let(:params) { {:externalscripts => '/usr/lib/zabbix/externalscripts'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ExternalScripts=/usr/lib/zabbix/externalscripts$}
      end
    end  
  
    context 'with fpinglocation => 60' do
      let(:params) { {:fpinglocation => '60'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^FpingLocation=60$}
      end
    end    
  
    context 'with unreachabedelay => /usr/sbin/fping' do
      let(:params) { {:unreachabedelay => '/usr/sbin/fping'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachableDelay=/usr/sbin/fping$}
      end
    end 

    context 'with fping6location => /usr/sbin/fping6' do
      let(:params) { {:fping6location => '/usr/sbin/fping6'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Fping6Location=/usr/sbin/fping6$}
      end
    end  

    context 'with sshkeylocation => /home/zabbix/.ssh/' do
      let(:params) { {:sshkeylocation => '/home/zabbix/.ssh/'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^SSHKeyLocation=/home/zabbix/.ssh/$}
      end
    end   

    context 'with loglowqueries => 0' do
      let(:params) { {:loglowqueries => '0'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogSlowQueries=0$}
      end
    end 

    context 'with tmpdir => /tmp' do
      let(:params) { {:tmpdir => '/tmp'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^TmpDir=/tmp$}
      end
    end  

    context 'with allowroot => 0' do
      let(:params) { {:allowroot => '0',:zabbix_version => '2.2'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^AllowRoot=0$}
      end
    end  

    context 'with include_dir => /etc/zabbix/zabbix_proxy.conf.d' do
      let(:params) { {:include_dir => '/etc/zabbix/zabbix_proxy.conf.d'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Include=/etc/zabbix/zabbix_proxy.conf.d$}
      end
    end
    
    context 'with loadmodulepath => ${libdir}/modules' do
      let(:params) { {:loadmodulepath => '${libdir}/modules'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$}
      end
    end  

    context 'with loadmodule => pizza' do
      let(:params) { {:loadmodule => 'pizza'} }
      it do
        should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LoadModule=pizza$}
      end
    end  
  end # END context 'zabbix_proxy.conf configuration'
# END of file
end