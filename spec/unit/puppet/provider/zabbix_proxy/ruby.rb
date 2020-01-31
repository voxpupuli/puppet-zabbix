require 'spec_helper'

describe Puppet::Type.type(:zabbix_proxy).provider(:ruby) do
  let(:resource) do
    Puppet::Type.type(:zabbix_proxy).new(
      name: 'Testproxy'
    )
  end
  let(:provider) { resource.provider }

  it 'be an instance of the correct provider' do
    expect(provider).to be_an_instance_of Puppet::Type::Zabbix_proxy::ProviderRuby
  end

  %i[instances prefetch].each do |method|
    it "should respond to the class method #{method}" do
      expect(described_class).to respond_to(method)
    end
  end

  %i[create exists? destroy].each do |method|
    it "should respond to the instance method #{method}" do
      expect(described_class.new).to respond_to(method)
    end
  end
end
