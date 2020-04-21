require 'spec_helper'

describe Puppet::Type.type(:zabbix_proxy) do
  describe 'when validating params' do
    [
      :hostname,
      :provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'when validating properties' do
    [
      :ipaddress,
      :use_ip,
      :mode,
      :port
    ].each do |param|
      it "should have a #{param} property" do
        expect(described_class.attrtype(param)).to eq(:property)
      end
    end
  end

  describe 'namevar' do
    it 'has :hostname as its namevar' do
      expect(described_class.key_attributes).to eq([:hostname])
    end
  end

  describe 'port' do
    ['678', 573, 1, 65_535].each do |value|
      it "supports #{value} as a value to `port`" do
        expect { described_class.new(name: 'example_proxy', port: value) }.not_to raise_error
      end
    end
    ['foo', true, false, 1_000_000].each do |value|
      it "rejects #{value}" do
        expect { described_class.new(name: 'example_proxy', port: value) }.to raise_error(Puppet::Error, %r{invalid port})
      end
    end
  end

  describe 'ipaddress' do
    ['127.0.0.1', '2001:0db8:85a3:0000:0000:8a2e:0370:7334'].each do |value|
      it "supports #{value} as a value to `ipaddress`" do
        expect { described_class.new(name: 'example_proxy', ipaddress: value) }.not_to raise_error
      end
    end
    ['foo', true, false, 1_000_000, '192.463.0.1', '127.0.0.0.1'].each do |value|
      it "rejects #{value}" do
        expect { described_class.new(name: 'example_proxy', ipaddress: value) }.to raise_error(Puppet::Error, %r{Parameter ipaddress failed})
      end
    end
  end

  describe 'mode' do
    describe 'munging' do
      ['0', 0, 'active'].each do |value|
        it "#{value} is munged to :active" do
          proxy = described_class.new(title: 'example_proxy', mode: value)
          expect(proxy[:mode]).to eq(:active)
        end
      end
      ['1', 1, 'passive'].each do |value|
        it "#{value} is munged to :passive" do
          proxy = described_class.new(title: 'example_proxy', mode: value)
          expect(proxy[:mode]).to eq(:passive)
        end
      end
    end
  end

  describe 'autorequiring' do
    let(:config_file) do
      Puppet::Type.type(:file).new(name: '/etc/zabbix/api.conf', ensure: :file)
    end
    let(:catalog) do
      Puppet::Resource::Catalog.new
    end
    let(:resource) do
      described_class.new(name: 'example_proxy')
    end
    let(:relationships) do
      resource.autorequire
    end

    before do
      catalog.add_resource config_file
      catalog.add_resource resource
    end

    it 'resource has one relationship' do
      expect(relationships.size).to eq(1)
    end
    it 'relationship target is the zabbix_proxy resource' do
      expect(relationships[0].target).to eq(resource)
    end
    it 'relationship source is the config file' do
      expect(relationships[0].source).to eq(config_file)
    end
  end
end
