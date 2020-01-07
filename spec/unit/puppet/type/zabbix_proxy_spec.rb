require 'spec_helper'

describe Puppet::Type.type(:zabbix_proxy) do
  describe 'when validating params' do
    %i[
      hostname
      provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'when validating properties' do
    %i[
      ipaddress
      use_ip
      mode
      port
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
end
