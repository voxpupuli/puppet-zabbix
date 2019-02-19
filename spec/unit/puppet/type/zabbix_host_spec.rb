require 'spec_helper'
require 'unit/puppet/x/spec_zabbix_types'

describe Puppet::Type.type(:zabbix_host) do
  describe 'when validating params' do
    [
      :group_create,
      :hostname
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'when validating properties' do
    [
      :group,
      :groups,
      :id,
      :interfaceid,
      :ipaddress,
      :port,
      :proxy,
      :templates,
      :use_ip
    ].each do |param|
      it "should have a #{param} property" do
        expect(described_class.attrtype(param)).to eq(:property)
      end
    end
  end

  describe 'munge_boolean' do
    {
      true    => true,
      false   => false,
      'true'  => true,
      'false' => false,
      :true   => true,
      :false  => false
    }.each do |key, value|
      it "munges #{key.inspect} to #{value}" do
        expect(described_class.new(name: 'nobody').munge_boolean(key)).to eq value
      end
    end

    it 'fails on non boolean-ish values' do
      expect { described_class.new(name: 'nobody').munge_boolean('foo') }.to raise_error(Puppet::Error, 'munge_boolean only takes booleans')
    end
  end

  describe 'parameters' do
    describe 'hostname' do
      it_behaves_like 'generic namevar', :hostname
    end

    describe 'group_create' do
      it_behaves_like 'boolean parameter', :group_create, true

      { 'true' => true, 'false' => false, :true => true, :false => false }.each do |key, value|
        it "munge input value #{key.inspect} => #{value}" do
          object = described_class.new(name: 'nobody', group_create: key)
          expect(object[:group_create]).to eq(value)
        end
      end
    end
  end

  describe 'properties' do
    describe 'ensure' do
      it_behaves_like 'generic ensurable', :present
    end

    describe 'group' do
      it_behaves_like 'validated property', :group, nil, ['group1', 'Group One']
    end

    describe 'groups' do
      it_behaves_like 'array_matching property', :groups, nil

      let(:object) { described_class.new(name: 'nobody', groups: ['Group1', 'Group One']) }

      it 'ignores order of array' do
        expect(object.property(:groups).insync?(['Group One', 'Group1'])).to be true
      end
    end

    describe 'id' do
      it_behaves_like 'readonly property', :id
    end

    describe 'interfaceid' do
      it_behaves_like 'readonly property', :interfaceid
    end

    describe 'ipaddress' do
      it_behaves_like 'validated property', :ipaddress, nil, ['127.0.0.1', '10.0.1.2', 'fe80::21f:5133:f123:c23f/64']
    end

    describe 'port' do
      it_behaves_like 'validated property', :port, nil, [10_050, '10050', 12_345]

      let(:object) { described_class.new(name: 'nobody', port: 40) }

      it 'ignores port received as string' do
        expect(object.property(:port).insync?('40')).to be true
      end
    end

    describe 'proxy' do
      it_behaves_like 'validated property', :proxy, nil, ['proxy1.example.com', 'proxy1']
    end

    describe 'templates' do
      it_behaves_like 'validated property', :templates, nil, ['template1', 'Template One', ['template1', 'Template One']]
      it_behaves_like 'array_matching property', :templates

      let(:object) { described_class.new(name: 'nobody', templates: ['Template1', 'Template One']) }

      it 'ignores order of array' do
        expect(object.property(:templates).insync?(['Template One', 'Template1'])).to be true
      end
    end

    describe 'use_ip' do
      it_behaves_like 'boolean property', :use_ip, nil
    end
  end
end
