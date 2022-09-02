# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'

describe Puppet::Type.type(:zabbix_host).provider(:ruby) do
  let(:resource) do
    Puppet::Type.type(:zabbix_host).new(
      hostname: 'test1.example.com'
    )
  end
  let(:provider) { resource.provider }

  it 'be an instance of the correct provider' do
    expect(provider).to be_an_instance_of Puppet::Type::Zabbix_host::ProviderRuby
  end

  %i[instances prefetch].each do |method|
    it "responds to the class method #{method}" do
      expect(described_class).to respond_to(method)
    end
  end

  %i[create exists? destroy get_groupids get_templateids ipaddress use_ip port groups templates macros proxy].each do |method|
    it "responds to the instance method #{method}" do
      expect(described_class.new).to respond_to(method)
    end
  end
end
