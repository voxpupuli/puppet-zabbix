# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix_host' do
  let(:title) { 'test1.example.com' }

  context 'with default provider' do
    it { is_expected.to be_valid_type.with_provider(:ruby) }

    it { is_expected.to be_valid_type.with_properties('ensure') }
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

    it { is_expected.to be_valid_type.with_properties('tls_psk') }
    it { is_expected.to be_valid_type.with_properties('tls_psk_identity') }
    it { is_expected.to be_valid_type.with_parameters('update_psk') }
  end

  context 'when tls_connect is psk but tls_psk and tls_psk_identity are missing' do
    it 'raises an error' do
      expect do
        Puppet::Type.type(:zabbix_host).new(
          name: 'psk-test.example.com',
          tls_connect: 'psk'
        )
      end.to raise_error(Puppet::Error, %r{tls_psk.*tls_psk_identity.*required}i)
    end
  end

  context 'when tls_accept is psk but tls_psk and tls_psk_identity are missing' do
    it 'raises an error' do
      expect do
        Puppet::Type.type(:zabbix_host).new(
          name: 'psk-test2.example.com',
          tls_accept: 'psk'
        )
      end.to raise_error(Puppet::Error, %r{tls_psk.*tls_psk_identity.*required}i)
    end
  end

  context 'when tls_connect is psk and tls_psk + tls_psk_identity are provided' do
    it 'does not raise an error' do
      expect do
        Puppet::Type.type(:zabbix_host).new(
          name: 'psk-test3.example.com',
          tls_connect: 'psk',
          tls_psk: 'abcdef0123456789abcdef0123456789',
          tls_psk_identity: 'my_psk_id'
        )
      end.not_to raise_error
    end
  end

  context 'when tls_connect is unencrypted without psk params' do
    it 'does not raise an error' do
      expect do
        Puppet::Type.type(:zabbix_host).new(
          name: 'nopsk-test.example.com',
          tls_connect: 'unencrypted'
        )
      end.not_to raise_error
    end
  end
end
