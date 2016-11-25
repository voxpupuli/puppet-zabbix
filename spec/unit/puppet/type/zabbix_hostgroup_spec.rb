require 'spec_helper'

describe Puppet::Type.type(:zabbix_hostgroup) do
  describe 'when validating attributes' do
    [:name, :zabbix_url, :zabbix_user, :zabbix_pass, :apache_use_ssl, :provider].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end
end
