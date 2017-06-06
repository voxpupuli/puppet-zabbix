require 'spec_helper_acceptance'

describe 'zabbix::server class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      # this is a minimal working example if you've a postgres server
      # running on another node. multinode testing with beaker is pain,
      # so we will deploy multiple services into one box
      # pp = <<-EOS
      # class { 'zabbix::server':
      #  manage_database => false,
      # }
      # EOS

      # this will actually deploy apache + postgres + zabbix-server + zabbix-web
      pp = <<-EOS
        class { 'postgresql::server': } ->
        class { 'zabbix::database': } ->
        class { 'zabbix::server': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # do some basic checks
    describe package('zabbix-server-pgsql') do
      it { is_expected.to be_installed }
    end

    describe service('zabbix-server') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
