require 'spec_helper'

describe 'zabbix_host' do
  let(:title) { 'test1.example.com' }

  context 'with default provider' do
    it { is_expected.to be_valid_type.with_provider(:ruby) }

    it { is_expected.to be_valid_type.with_properties('ensure') }
    it { is_expected.to be_valid_type.with_properties('group') }
    it { is_expected.to be_valid_type.with_properties('groups') }
    it { is_expected.to be_valid_type.with_properties('id') }
    it { is_expected.to be_valid_type.with_properties('interfaceid') }
    it { is_expected.to be_valid_type.with_properties('ipaddress') }
    it { is_expected.to be_valid_type.with_properties('port') }
    it { is_expected.to be_valid_type.with_properties('proxy') }
    it { is_expected.to be_valid_type.with_properties('templates') }
    it { is_expected.to be_valid_type.with_properties('macros') }
    it { is_expected.to be_valid_type.with_properties('use_ip') }

    it { is_expected.to be_valid_type.with_parameters('hostname') }
    it { is_expected.to be_valid_type.with_parameters('group_create') }
  end
end
